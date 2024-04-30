//
//  DiariesView.swift
//  TCA_Diary
//
//  Created by 최서연 on 4/9/24.
//

import ComposableArchitecture
import SwiftUI

struct DiariesView: View {
  @Bindable var store: StoreOf<Diaries>

  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      List {
        Button("일기 추가하기") {
          store.send(.createDiaryButtonTapped)
        }

        ForEachStore(self.store.scope(state: \.diaries, action: \.diaries)) { store in

          NavigationLink(
            state: AppFeature.Path.State.detail(Diary.State(syncUp: syncUp))
          ) {
            DiaryRow(store: store)
          }
        }
        .onAppear {
          store.send(.getDiaries)
        }
      }
    }
  }
}
