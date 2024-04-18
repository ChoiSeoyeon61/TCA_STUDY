//
//  DiaryDetailView.swift
//  TCA_Diary
//
//  Created by 최서연 on 4/17/24.
//

import SwiftUI
import ComposableArchitecture

struct DiaryDetailView: View {
  var store: StoreOf<Diary>
  
  var body: some View {
    VStack(alignment: .leading, spacing: 30) {
      VStack(alignment: .leading, spacing: 10) {
        Text(store.date.toString(.regularDateOnly))
          .bold()
          .fontSize(20)
        
        Text("최종 수정 일시: " + store.updatedAt.toString(.regularDate))
          .fontSize(12)
          .foregroundColor(.gray.opacity(0.7))
      }
      
      VStack(alignment: .leading, spacing: 10) {
        Text("내용")
          .fontSize(15)
          .bold()
        
        Text(store.description)
          .fontSize(15)
          .lineSpacing(5)
      }
      
      Spacer()
    }
    .fillWidth()
    .foregroundColor(.black.opacity(0.9))
    .padding(24)
    .navigationTitle(store.title)
    .navigationBarItems(
      trailing: HStack(spacing: 20) {
        Button(store.editMode == .active ? "저장" : "편집") {
          store.send(.toggleEditMode)
        }
      }
    )
  }
}

