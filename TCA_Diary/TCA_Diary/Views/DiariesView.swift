//
//  DiariesView.swift
//  TCA_Diary
//
//  Created by 최서연 on 4/9/24.
//

import SwiftUI
import ComposableArchitecture

struct DiariesView: View {
  @Bindable var store: StoreOf<Diaries>

  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      NavigationStack(path: $store.scope(state: \.destination, action: \.destination)) {
        List {
          Button("일기 추가하기") {
            store.send(.createDiaryButtonTapped)
          }
          
          ForEachStore(self.store.scope(state: \.diaries, action: \.diaries)) { store in
            DiaryRow(store: store)
          }
        }
        .onAppear {
          store.send(.getDiaries)
        }
      } destination: { store in
        switch store.case {
        case let .select(store):
          DiaryDetailView(store: store)
        case let .creating(store):
          DiaryCreateView(store: store)
        }
      }
    }
  }
}
