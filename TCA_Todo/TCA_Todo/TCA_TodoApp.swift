//
//  TCA_TodoApp.swift
//  TCA_Todo
//
//  Created by 최서연 on 3/27/24.
//

import SwiftUI
import ComposableArchitecture

@main
struct TCA_TodoApp: App {
  var body: some Scene {
    WindowGroup {
      AppView(store: Store(initialState: Todos.State(), reducer: {
        Todos()
      }))
    }
  }
}


