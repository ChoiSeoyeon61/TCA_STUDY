//
//  DiaryCreateView.swift
//  TCA_Diary
//
//  Created by 최서연 on 4/9/24.
//

import ComposableArchitecture
import Foundation
import SwiftUI

struct DiaryCreateView: View {
  @Bindable var store: StoreOf<CreatingDiary>
  
  var body: some View {
    ScrollView {
      VStack(alignment: .leading) {
        datePicker()
          
        titleField()
      
        descEditor()
        
        photoAttachment()
        
        submitButton()
      }
    }
    .sheet(isPresented: $store.isImagePickerPresented) {
      PhotoPicker(selectedImage: $store.image, sourceType: .photoLibrary)
    }
    .navigationTitle("일기 작성하기")
    .padding(24)
    .multilineTextAlignment(.leading)
    .interactiveDismissDisabled()
  }
  
  private func datePicker() -> some View {
    DatePicker("날짜", selection: $store.date)
      .padding(.bottom, 20)
  }
  
  private func titleField() -> some View {
    HStack(spacing: 30) {
      Text("제목")
      TextField("제목을 입력하세요.", text: $store.title)
    }
    .padding(.bottom, 20)
  }
  
  private func descEditor() -> some View {
    VStack(alignment: .leading, spacing: 8) {
      Text("내용")
      
      TextEditor(text: $store.description)
        .overlay(
          RoundedRectangle(cornerRadius: 10)
            .stroke(.gray.opacity(0.5))
        )
        .frame(height: 200)
        .padding(.bottom, 40)
    }
  }
  
  private func photoAttachment() -> some View {
    VStack {
      if let image = store.image {
        Image(uiImage: image)
          .resizable()
          .scaledToFill()
          .frame(width: 300, height: 150)
          .clipped()
      } else {
        Button("사진 첨부하기") {
          store.send(.openPhotoPicker)
        }
      }
    }
  }
  
  private func submitButton() -> some View {
    Button("제출") {
      store.send(.submitDiary)
    }
    .padding(8, 0, 0, 8)
  }
}
