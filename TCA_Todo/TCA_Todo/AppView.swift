//
//  AppView.swift
//  TCA_Todo
//
//  Created by 최서연 on 3/27/24.
//

import SwiftUI
import ComposableArchitecture

struct AppView: View {
  var store: StoreOf<Todos>
  
  var body: some View {
    NavigationStack {
      VStack {
        List {
          ForEach(store.scope(state: \.todos, action: \.todos)) { store in
            TodoRow(store: store)
          }
        }
      }
      .navigationTitle("Todos")
      .navigationBarItems(trailing: Button("Add Todo") {
        store.send(.addTodoButtonTapped)
      })
    }
    
  }
}


