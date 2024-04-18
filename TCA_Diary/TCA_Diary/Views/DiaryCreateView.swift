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
  
  // presentation back(environment): presentationMode
  // 그 외는 안 넣으신다고 함
  // 써보는 연습?
  
  var body: some View {
    VStack(alignment: .leading) {
      
      DatePicker("날짜", selection: $store.date)
        .padding(.bottom, 20)
        
      
      HStack(spacing: 30) {
        Text("제목")
        TextField("제목을 입력하세요.", text: $store.title)
      }
      .padding(.bottom, 20)
      
      Text("내용")
      
      TextEditor(text: $store.description)
        .overlay(
          RoundedRectangle(cornerRadius: 10)
            .stroke(.gray.opacity(0.5))
        )
        .frame(height: 200)
      
      Spacer()
      
      Button("제출") {
        store.send(.submitDiary)
      }
    }
    .navigationTitle("일기 작성하기")
    .padding(24)
    .multilineTextAlignment(.leading)
    .interactiveDismissDisabled()
    
  }
}
