import SwiftUI
import AVFoundation

/// 카메라 뷰, 레이어.
/// 캡처세션은 밖에서 주입함
public struct CameraPreviewView: UIViewRepresentable {
  public class VideoPreviewView: UIView {
    public override class var layerClass: AnyClass {
      AVCaptureVideoPreviewLayer.self
    }
    
    var videoPreviewLayer: AVCaptureVideoPreviewLayer {
      return layer as! AVCaptureVideoPreviewLayer
    }
  }
  
  let session: AVCaptureSession
  
  public init(session: AVCaptureSession) {
    self.session = session
  }
  
  public func makeUIView(context: Context) -> VideoPreviewView {
    let view = VideoPreviewView()
    
    view.videoPreviewLayer.session = session
    view.backgroundColor = .black
    view.videoPreviewLayer.videoGravity = .resizeAspectFill
    view.videoPreviewLayer.cornerRadius = 0
    view.videoPreviewLayer.connection?.videoOrientation = .portrait
    
    return view
  }
  
  public func updateUIView(_ uiView: VideoPreviewView, context: Context) {
    
  }
}
