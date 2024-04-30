import UIKit
import SwiftUI
import AVFoundation

/// AVCaptureDevice, AVCaptureSession 관리 모듈. 뷰x?
class Camera {
  private var position = AVCaptureDevice.Position.back
  private let quality = AVCaptureSession.Preset.photo
  
  private(set) var isPermissionGranted: Bool?
  private let sessionQueue = DispatchQueue(
    label: "session queue",
    qos: .userInteractive
  )
  let captureSession = AVCaptureSession()
  private let context = CIContext()
  
  init() {
    checkPermission()
    sessionQueue.async { [unowned self] in
      self.configureSession()
      self.captureSession.startRunning()
    }
  }
  
  // MARK: AVSession configuration
  private func checkPermission() {
    switch AVCaptureDevice.authorizationStatus(for: .video) {
    case .authorized:
      isPermissionGranted = true
    case .notDetermined:
      requestPermission()
    default:
      isPermissionGranted = false
    }
  }
  
  private func requestPermission() {
    sessionQueue.suspend()
    AVCaptureDevice.requestAccess(for: .video) { [unowned self] granted in
      self.isPermissionGranted = granted
      self.sessionQueue.resume()
    }
  }
  
  private func configureSession(isReconfigure: Bool = false) {
    guard isPermissionGranted == true else { return }
    if !isReconfigure {
      captureSession.sessionPreset = quality
    }
    guard let captureDevice = selectCaptureDevice() else { return }
    guard let captureDeviceInput = try? AVCaptureDeviceInput(device: captureDevice) else { return }
    guard captureSession.canAddInput(captureDeviceInput) else { return }
    if isReconfigure {
      captureSession
        .inputs
        .forEach(captureSession.removeInput(_:))
    }
    captureSession.addInput(captureDeviceInput)
    
    if !isReconfigure {
      let photoOutput = AVCapturePhotoOutput()
      photoOutput.isHighResolutionCaptureEnabled = true
      photoOutput.maxPhotoQualityPrioritization = .quality
      guard captureSession.canAddOutput(photoOutput) else { return }
      captureSession.addOutput(photoOutput)
    }
    guard
      let connection = captureSession.outputs
        .first(where: { $0 is AVCapturePhotoOutput })?
        .connection(with: .video),
      connection.isVideoOrientationSupported,
      connection.isVideoMirroringSupported
    else { return }
    connection.videoOrientation = .portrait
    connection.isVideoMirrored = position == .front
  }
  
  private func selectCaptureDevice() -> AVCaptureDevice? {
    AVCaptureDevice.default(
      .builtInWideAngleCamera,
      for: .video,
      position: position
    )
  }
  
  func capturePhoto() async throws -> UIImage? {
    return try await AsyncThrowingStream<UIImage, Error> { continuation in
      Task {
        let delegate = Delegate(continuation: continuation)
        continuation.onTermination = { _ in
          _ = delegate
          Task { self.sessionQueue.suspend() } // TODO: 이후 다시찍기 시 resume 필요
        }
        
        let photoSettings = AVCapturePhotoSettings()
        let photoOutput = self.captureSession.outputs
          .first(
            where: { $0 is AVCapturePhotoOutput }
          ) as? AVCapturePhotoOutput
        photoOutput?.connection(with: .video)?
          .videoOrientation = await UIDevice.current.captureVideoOrientation
        photoOutput?.capturePhoto(with: photoSettings, delegate: delegate)
      }
    }
    .first(where: { _ in true })
  }
  
  func cameraSwitch() {
    switch position {
    case .back:
      position = .front
    default:
      position = .back
    }
    
    sessionQueue.async { [unowned self] in
      self.captureSession.beginConfiguration()
      self.configureSession(isReconfigure: true)
      self.captureSession.commitConfiguration()
    }
  }
}

extension Camera {
  func suspendQueue() -> Void {
    sessionQueue.suspend()
  }
  
  func resumeQueue() -> Void {
    sessionQueue.resume()
  }
}


/// delegate
extension Camera {
  final class Delegate: NSObject, AVCapturePhotoCaptureDelegate {
    let continuation: AsyncThrowingStream<UIImage, Error>.Continuation
    
    init(continuation: AsyncThrowingStream<UIImage, Error>.Continuation) {
      self.continuation = continuation
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
      if let error {
        continuation.finish(throwing: error)
      }
      guard
        let imageData = photo.fileDataRepresentation(),
        let uiImage = UIImage(data: imageData)?.fixedOrientation()
      else {
        return
      }
      continuation.yield(uiImage)
      continuation.finish()
    }
  }
}

extension UIDevice {
  var captureVideoOrientation: AVCaptureVideoOrientation {
    switch self.orientation {
    case .portrait: return .portrait
    case .landscapeLeft: return .landscapeLeft
    case .landscapeRight: return .landscapeRight
    case .portraitUpsideDown: return .portraitUpsideDown
    default: return .portrait
    }
  }
}
