//
//  PhotoPicker.swift
//  TCA_Diary
//
//  Created by 최서연 on 4/24/24.
//

import SwiftUI
import UIKit

struct PhotoPicker: UIViewControllerRepresentable {
  @Environment(\.dismiss) private var dismiss

  @Binding var selectedImage: UIImage?
  
  var sourceType: UIImagePickerController.SourceType

  func makeUIViewController(context: UIViewControllerRepresentableContext<Self>) -> UIImagePickerController {
    let imagePicker = UIImagePickerController()
    imagePicker.allowsEditing = false
    imagePicker.sourceType = sourceType
    imagePicker.delegate = context.coordinator

    return imagePicker
  }

  func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<Self>) {}

  func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }
}


extension PhotoPicker {
  final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var parent: PhotoPicker

    init(_ parent: PhotoPicker) {
      self.parent = parent
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
      if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
        parent.selectedImage = image
      }

      parent.dismiss()
    }
  }
}
