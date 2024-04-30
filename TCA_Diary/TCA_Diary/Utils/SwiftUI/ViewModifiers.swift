//
//  ViewModifiers.swift
//  TCA_Diary
//
//  Created by 최서연 on 4/17/24.
//

import SwiftUI

struct PaddingModifier: ViewModifier {
  var top: CGFloat
  var leading: CGFloat
  var trailing: CGFloat
  var bottom: CGFloat

  func body(content: Content) -> some View {
    content
      .padding(.top, top)
      .padding(.leading, leading)
      .padding(.trailing, trailing)
      .padding(.bottom, bottom)
  }
}

struct FillWidthModifier: ViewModifier {
  var alignment: Alignment

  func body(content: Content) -> some View {
    content
      .frame(maxWidth: .infinity, alignment: alignment)
  }
}

struct FillWidthTextModifier: ViewModifier {
  let textAlign: TextAlignment

  var alignment: Alignment {
    switch textAlign {
    case .center:
      return .center
    case .leading:
      return .leading
    case .trailing:
      return .trailing
    }
  }

  func body(content: Content) -> some View {
    content
      .frame(maxWidth: .infinity, alignment: alignment)
  }
}

struct FillHeightModifier: ViewModifier {
  func body(content: Content) -> some View {
    content
      .frame(maxHeight: .infinity)
  }
}

struct FontSizeModifier: ViewModifier {
  var size: CGFloat

  func body(content: Content) -> some View {
    content
      .font(.system(size: size))
  }
}

// viewDidLoad
struct ViewDidLoadModifier: ViewModifier {
  @State private var didLoad = false
  private let action: (() -> Void)?

  init(perform action: (() -> Void)? = nil) {
    self.action = action
  }

  func body(content: Content) -> some View {
    content.onAppear {
      if didLoad == false {
        didLoad = true
        action?()
      }
    }
  }
}

struct TextStyleModifier: ViewModifier {
  var color: Color
  var size: CGFloat
  var weight: Font.Weight

  func body(content: Content) -> some View {
    content
      .font(.system(size: size, weight: weight))
      .foregroundColor(color)
  }
}


struct NavigationInlineTitleModifier: ViewModifier {
  var title: String
  
  func body(content: Content) -> some View {
    content
      .navigationBarTitleDisplayMode(.inline)
      .navigationTitle(title)
      .toolbarBackground(
        Color.white,
              for: .navigationBar
            )
      .toolbarBackground(.visible, for: .navigationBar)
  }
}


struct RoundedCorner: Shape {
  var radius: CGFloat = .infinity
  var corners: UIRectCorner = .allCorners

  func path(in rect: CGRect) -> Path {
    let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [corners], cornerRadii: CGSize(width: radius, height: radius))
    return Path(path.cgPath)
  }
}
