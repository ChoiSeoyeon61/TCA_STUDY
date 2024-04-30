//
//  PhotoLibraryClient.swift
//  TCA_Diary
//
//  Created by 최서연 on 4/24/24.
//

import Foundation
import UIKit
import ComposableArchitecture

@DependencyClient
struct PhotoLibraryClient {
  var present: @Sendable () async throws -> UIImage?
  var dismiss: @Sendable () async -> Void
}

extension DependencyValues {
  var photoPicker: PhotoLibraryClient {
    get { self[PhotoLibraryClient.self] }
    set { self[PhotoLibraryClient.self] = newValue }
  }
}

class VC {
  @MainActor
  static func getUIImagePickerController() -> UIImagePickerController {
    let vc = UIImagePickerController()
    vc.allowsEditing = false
    return vc
  }
}

extension PhotoLibraryClient: DependencyKey {
  static let liveValue = {
    let presenter = Presenter()
    return Self(
      present: { try await presenter.present()},
      dismiss: { await presenter.dismiss()}
    )
  }()
  
  actor Presenter {
    
    var viewController: UIImagePickerController?
    
    func present() async throws -> UIImage? {
      final class Delegate: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let continuation: AsyncThrowingStream<UIImage, Error>.Continuation
        
        init(continuation: AsyncThrowingStream<UIImage, Error>.Continuation) {
          self.continuation = continuation
        }

        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
          picker.dismiss(animated: true)
          
          if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
          {
            continuation.yield(image)
            continuation.finish()
          } else {
            continuation.finish()
          }
        }
      }
      
      await self.dismiss()
      
      let viewController = await VC.getUIImagePickerController()
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
      await viewController.dismiss(animated: true)
      self.viewController = nil
    }
  }
}

#if os(iOS)
  import UIKit

  @available(iOSApplicationExtension, unavailable)
  extension UIViewController {
    public func present() {
      guard
        let scene = UIKit.UIApplication.shared.connectedScenes.first(where: { $0 is UIWindowScene })
          as? UIWindowScene
      else { return }
      scene.keyWindow?.rootViewController?.present(self, animated: true)
    }

    public func dismiss() {
      self.dismiss(animated: true, completion: nil)
    }
  }
#endif
