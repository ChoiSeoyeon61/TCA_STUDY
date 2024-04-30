import AVFoundation.AVCaptureSession
import Dependencies
import UIKit

extension DependencyValues {
  public var photo: PhotoClient {
    get { self[PhotoClient.self] }
    set { self[PhotoClient.self] = newValue }
  }
}

public struct PhotoClient {
  public var camera: CameraClient
  public var photoLibrary: PhotoLibraryClient
}

public struct CameraClient {
  public var capture: @Sendable () async throws -> UIImage?
  public var cameraSwitch: @Sendable () -> Void
  public var isPermissionGranted: @Sendable () -> Bool? // true: granted, false: not, nil: yet
  public var captureSession: @Sendable () -> AVCaptureSession
  public var suspendQueue: @Sendable () -> Void
  public var resumeQueue: @Sendable () -> Void
  
}

public struct PhotoLibraryClient {
  public var present: @Sendable () async throws -> UIImage?
  public var dismiss: @Sendable () async -> Void
}

extension DependencyValues {
  public var authority: AuthorityClient {
    get { self[AuthorityClient.self] }
    set { self[AuthorityClient.self] = newValue }
  }
}

public struct AuthorityClient {
  public var isPermissionGranted: @Sendable () -> Bool? // true: granted, false: not, nil: yet
  public var requestAccess: @Sendable () async -> Bool
  public var openCameraSetting: @Sendable () async -> Void
}
