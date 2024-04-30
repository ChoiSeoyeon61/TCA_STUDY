//
//  TCA_DiaryApp.swift
//  TCA_Diary
//
//  Created by 최서연 on 4/9/24.
//

import SwiftUI
import ComposableArchitecture

@main
struct TCA_DiaryApp: App {
  let store = Store(initialState: AppFeature.State()) {
    AppFeature()
      ._printChanges()
  }
  
  var body: some Scene {
    WindowGroup {
      AppView(store: store)
    }
  }
}

@Reducer
struct AppFeature {
  @Reducer(state: .equatable)
  enum Path {
    case detail(Diary)
    case create(CreatingDiary)
  }

  @ObservableState
  struct State: Equatable {
    var path = StackState<Path.State>()
    var diaries = Diaries.State()
  }

  enum Action {
    case path(StackActionOf<Path>)
    case diaries(Diaries.Action)
  }

  @Dependency(\.date.now) var now
  @Dependency(\.uuid) var uuid

  var body: some ReducerOf<Self> {
    Scope(state: \.diaries, action: \.diaries) {
      Diaries()
    }
    Reduce { state, action in
      switch action {
        
      case .path:
        return .none

      case .diaries:
        return .none
      }
    }
    .forEach(\.path, action: \.path)
  }
}

struct AppView: View {
  @Bindable var store: StoreOf<AppFeature>

  var body: some View {
    NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
      DiariesView(store: store.scope(state: \.diaries, action: \.diaries))
    } destination: { store in
      switch store.case {
      case let .detail(store):
        DiaryDetailView(store: store)
      case let .create(store):
        DiaryCreateView(store: store)
      }
    }
  }
}
