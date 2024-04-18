//
//  DiaryRow.swift
//  TCA_Diary
//
//  Created by 최서연 on 4/9/24.
//

import Foundation
import SwiftUI
import ComposableArchitecture

struct DiaryRow: View {
  var store: StoreOf<Diary>
  
  var body: some View {
    HStack {
      Text(store.date.toString(.dotDateOnly))
      
      Spacer()
      
      Text(store.title)
    }
    .onTapGesture {
      store.send(.openDiary)
    }
  }
}
