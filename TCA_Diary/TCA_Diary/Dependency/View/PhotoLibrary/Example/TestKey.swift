import Foundation
import XCTestDynamicOverlay

extension PhotoClient {
  public static let previewValue = Self.noop

  public static let testValue = Self(
    camera: .testValue,
    photoLibrary: .testValue
  )
}

extension PhotoClient {
  public static let noop = Self(
    camera: .noop,
    photoLibrary: .noop
  )
}

extension CameraClient {
  public static let testValue = Self(
    capture: XCTUnimplemented("\(Self.self).capture"),
    cameraSwitch: XCTUnimplemented("\(Self.self).cameraSwitch"),
    isPermissionGranted: XCTUnimplemented("\(Self.self).isPermissionGranted"),
    captureSession: XCTUnimplemented("\(Self.self).captureSession"),
    suspendQueue: XCTUnimplemented("\(Self.self).suspendQueue"),
    resumeQueue: XCTUnimplemented("\(Self.self).resumeQueue")
  )
  public static var noop: Self {
    return Self(
      capture: { nil },
      cameraSwitch: {},
      isPermissionGranted: { nil },
      captureSession: { .init() },
      suspendQueue: {},
      resumeQueue: {}
    )
  }
}

extension PhotoLibraryClient {
  public static var testValue: Self {
    return Self(
      present: XCTUnimplemented("\(Self.self).present"),
      dismiss: XCTUnimplemented("\(Self.self).dismiss")
    )
  }
  public static var noop: Self {
    return Self(
      present: { nil },
      dismiss: { () }
    )
  }
}

extension AuthorityClient {
  public static let previewValue = Self.noop
  
  public static let testValue = Self(
    isPermissionGranted: XCTUnimplemented("\(Self.self).isPermissionGranted"),
    requestAccess: XCTUnimplemented("\(Self.self).requestAccess"),
    openCameraSetting: XCTUnimplemented("\(Self.self).openCameraSetting")
  )
  public static var noop: Self {
    return Self(
      isPermissionGranted: { nil },
      requestAccess: { true },
      openCameraSetting: {}
    )
  }
}
