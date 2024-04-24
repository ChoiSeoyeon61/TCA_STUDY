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
          
          if let project = viewStore.project { // Q: Referencing subscript 'subscript(dynamicMember:)' on 'Store' requires that 'Diaries.State' conform to 'ObservableState' 때문에 viewStore 사용했는데, self.store랑 같이 혼재되는 이게 맞나... 싶고(그렇다고 @observableState 쓰면 presentationState를 사용할 수 없음..)
            Text(project.name)
          }
        }
        .onAppear {
          store.send(.getProject)
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
