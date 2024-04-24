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
      NavigationStack {
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
        .navigationDestination(
          store: store.scope(state: \.$creatingDiary, action: \.creatingDiary),
          destination: DiaryCreateView.init
        )
        .navigationDestination(
          store: store.scope(state: \.$selectedDiary, action: \.selectedDiary),
          destination: DiaryDetailView.init
        )
      }
    }
  }
}
