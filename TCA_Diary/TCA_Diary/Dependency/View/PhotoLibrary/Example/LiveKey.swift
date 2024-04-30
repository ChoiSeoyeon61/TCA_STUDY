import AVFoundation
import Dependencies
import FoundationKit
import PhotosUI
import UIKit

extension PhotoClient: DependencyKey {
  public static let liveValue = Self(
    camera: .live,
    photoLibrary: .live
  )
}

extension CameraClient {
  public static var live: Self {
    let camera = Camera()
    
    return Self(
      capture: { try await camera.capturePhoto() },
      cameraSwitch: { camera.cameraSwitch() },
      isPermissionGranted: { camera.isPermissionGranted },
      captureSession: { camera.captureSession },
      suspendQueue: { camera.suspendQueue() },
      resumeQueue: { camera.resumeQueue() }
    )
  }
}

extension PhotoLibraryClient {
  public static var live: Self {
    let presenter = Presenter()
    
    return Self(
      present: { try await presenter.present() },
      dismiss: { await presenter.dismiss() }
    )
    
    actor Presenter {
      var viewController: PHPickerViewController?
      
      func present() async throws -> UIImage? {
        final class Delegate: NSObject, PHPickerViewControllerDelegate {
          let continuation: AsyncThrowingStream<UIImage, Error>.Continuation
          
          init(continuation: AsyncThrowingStream<UIImage, Error>.Continuation) {
            self.continuation = continuation
          }

          func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult])
          {
            picker.dismiss(animated: true)

            guard
              let itemProvider = results.first?.itemProvider,
              itemProvider.canLoadObject(ofClass: UIImage.self)
            else {
              return
            }
            itemProvider.loadObject(ofClass: UIImage.self) { (uiImage, error) in
              guard let image = uiImage as? UIImage
              else {
                self.continuation.finish(throwing: error)
                return
              }
              self.continuation.yield(image)
              self.continuation.finish()
            }
          }
        }
        
        await self.dismiss()
        
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .any(of: [.images])
        let viewController = await PHPickerViewController(configuration: configuration)
        self.viewController = viewController
        return try await AsyncThrowingStream<UIImage, Error> { continuation in
          Task {
            await MainActor.run {
              let delegate = Delegate(continuation: continuation)
              continuation.onTermination = { _ in
                _ = delegate
              }
              viewController.delegate = delegate
              viewController.present()
            }
          }
        }
        .first(where: { _ in true })
      }
      
      func dismiss() async {
        guard let viewController = self.viewController else { return }
        await viewController.dismiss()
        self.viewController = nil
      }
    }
  }
}

extension AuthorityClient: DependencyKey {
  public static var liveValue: Self {
    return Self(
      isPermissionGranted: {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined:
          return nil
        case .authorized:
          return true
        default:
          return false
        }
      },
      requestAccess: {
        await AVCaptureDevice.requestAccess(for: .video)
      },
      openCameraSetting: {
        await MainActor.run {
          guard
            let url = URL(string: UIApplication.openSettingsURLString),
            UIApplication.shared.canOpenURL(url)
          else { return }
          UIApplication.shared.open(url)
        }
      }
    )
  }
}
