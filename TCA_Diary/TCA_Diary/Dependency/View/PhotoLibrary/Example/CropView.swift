import DesignSystem
import StringsKit
import SwiftUI
import UIComponents

public enum Crop: Equatable {
  case circle
  case square
}

struct Hole: Shape {
  let crop: Crop
  let holeSize: CGSize
  
  func path(in rect: CGRect) -> Path {
    let path = CGMutablePath()
    path.move(to: rect.origin)
    path.addLine(to: .init(x: rect.maxX, y: rect.minY))
    path.addLine(to: .init(x: rect.maxX, y: rect.maxY))
    path.addLine(to: .init(x: rect.minX, y: rect.maxY))
    path.addLine(to: rect.origin)
    path.closeSubpath()
    
    let newRect = CGRect(
      origin: .init(
        x: rect.midX - holeSize.width / 2,
        y: rect.midY - holeSize.height / 2
      ),
      size: holeSize
    )
    
    switch crop {
    case .circle:
      path.addEllipse(in: newRect, transform: .identity)
    case .square:
      path.addRoundedRect(in: newRect, cornerWidth: 12, cornerHeight: 12)
    }
    path.closeSubpath()
    return Path(path)
  }
}

public struct CropImageView: View {
  public enum Constant {
    static let cropViewCoordinateName = "CROPVIEW"
  }
  
  var crop: Crop
  var inputImage: UIImage
  var onCrop: (UIImage?) -> Void
  var size: CGSize {
    let screenLength: CGFloat = min(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height)
    return .init(width: screenLength - 20 * 2, height: screenLength - 20 * 2)
  }
  
  @Environment(\.presentationMode) var presentationMode
  
  /// - Gesture Properties
  @State private var scale: CGFloat = 1.0
  @State private var lastScale: CGFloat = 0
  @State private var offset: CGSize = .zero
  @State private var lastStoredOffset: CGSize = .zero
  @GestureState private var isInteracting: Bool = false
  
  public init(
    crop: Crop,
    inputImage: UIImage,
    onCrop: @escaping (UIImage?) -> Void
  ) {
    self.crop = crop
    self.inputImage = inputImage
    self.onCrop = onCrop
  }
  
  public var body: some View {
    GeometryReader { proxy in
      ZStack(alignment:. bottom) {
        ZStack {
          self.imageView
          Hole(crop: self.crop, holeSize: self.size)
            .fill(
              .black.opacity(0.5),
              style: FillStyle(eoFill: true, antialiased: true)
            )
            .allowsHitTesting(false)
        }
        .edgesIgnoringSafeArea(.all)

        PrimaryButton(
          title: Literals.PayLogEditorGalleryBtn,
          style: .filledPrimary
        ) {
          let resultImage = self.inputImage.cropTheImageWithImageViewSize(
            size: self.size,
            zoomScale: self.scale,
            offset: self.offset
          )
          self.onCrop(resultImage)
        }
        .pillButtonSize(.buttonLargeFill)
        .padding(20)
      }
    }
    .navigationBarTitle(Text(""), displayMode: .inline)
    .navigationBarBackButtonHidden(true)
    .navigationBarItems(
      trailing: NavigationButton.close
        .button(color: .neutrals.white) {
          presentationMode.wrappedValue.dismiss()
        }
    )
    .background(Color.secondary.black.edgesIgnoringSafeArea(.all))
    .preferredColorScheme(.light)
  }
  
  var imageView: some View {
    GeometryReader {
      let size = $0.size
      Image(uiImage: inputImage)
        .resizable()
        .aspectRatio(contentMode: .fill)
        .overlay {
          GeometryReader { proxy in
            let rect = proxy.frame(in: .named(Constant.cropViewCoordinateName))
            
            Color.clear
              .onChange(of: isInteracting) { newValue in
                withAnimation(.easeIn(duration: 0.2)) {
                  if rect.minX > 0 {
                    offset.width = offset.width - rect.minX
                  }
                  if rect.minY > 0 {
                    offset.height = offset.height - rect.minY
                  }
                  if rect.maxX < size.width {
                    offset.width = rect.minX - offset.width
                  }
                  if rect.maxY < size.height {
                    offset.height = rect.minY - offset.height
                  }
                }
              }
          }
        }
        .frame(width: size.width, height: size.height)
    }
    .frame(width: size.width, height: size.height)
    .onChange(of: isInteracting, perform: { newValue in
      if !newValue {
        lastStoredOffset = offset
      }
    })
    .scaleEffect(self.scale)
    .offset(self.offset)
    .coordinateSpace(name: Constant.cropViewCoordinateName)
    .gesture(
      DragGesture()
        .updating($isInteracting, body: { _, out, _ in
          out = true
        })
        .onChanged { value in
          let translation = value.translation
          self.offset = .init(
            width: translation.width + lastStoredOffset.width,
            height: translation.height + lastStoredOffset.height
          )
        }
    )
    .gesture(MagnificationGesture()
      .updating($isInteracting, body: { _, out, _ in
        out = true
      })
        .onChanged { value in
          let updatedScale = value + lastScale
          scale = updatedScale < 1 ? 1 : updatedScale
        }
      .onEnded { value in
        withAnimation(.easeInOut(duration: 0.2)) {
          if scale < 1 {
            scale = 1
            lastScale = 0
          } else {
            lastScale = scale - 1
          }
        }
      }
    )
  }
}
