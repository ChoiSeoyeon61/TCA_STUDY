//
//  ViewExtension.swift
//  TCA_Diary
//
//  Created by 최서연 on 4/17/24.
//

import SwiftUI

extension View {
  func padding(_ top: CGFloat, _ leading: CGFloat, _ trailing: CGFloat, _ bottom: CGFloat) -> some View {
    modifier(PaddingModifier(top: top, leading: leading, trailing: trailing, bottom: bottom))
  }

  func fillWidth() -> some View {
    modifier(FillWidthModifier(alignment: .center))
  }

  func fillWidth(textAlign textAlignment: TextAlignment) -> some View {
    modifier(FillWidthTextModifier(textAlign: textAlignment))
  }

  func fillHeight() -> some View {
    modifier(FillHeightModifier())
  }


  func fontSize(_ size: CGFloat) -> some View {
    modifier(FontSizeModifier(size: size))
  }

  /// 사용 예시: .cornerRadius(15, corners: [.topLeft, .topRight])
  func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
    clipShape(RoundedCorner(radius: radius, corners: corners))
  }

  func onLoad(perform action: (() -> Void)? = nil) -> some View {
    modifier(ViewDidLoadModifier(perform: action))
  }

  func navigationInlineTitle(_ title: String) -> some View {
    modifier(NavigationInlineTitleModifier(title: title))
  }

  /// getStream 내부에서 가져옴 - Method for making a haptic feedback.
  func triggerHapticFeedbackCopy(style: UIImpactFeedbackGenerator.FeedbackStyle) {
    let generator = UIImpactFeedbackGenerator(style: style)
    generator.impactOccurred()
  }
}
