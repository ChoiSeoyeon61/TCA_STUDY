//
//  Todo.swift
//  TCA_Todo
//
//  Created by 최서연 on 3/27/24.
//

import Foundation
import ComposableArchitecture
import SwiftUI

@Reducer
struct Todo {
  @ObservableState
  struct State: Equatable, Identifiable {
    var id: UUID // identifiedArrayof를 위한 건감
    var title: String = "title"
    var isFinished = false
  }
  
  enum Action: BindableAction, Sendable {
    case binding(BindingAction<State>)
    
  }
  
  var body: some Reducer<State, Action> {
    BindingReducer()
  }
}


struct TodoRow: View {
  @Perception.Bindable var store: StoreOf<Todo>
  
  var body: some View {
    TextField("asdf", text: $store.title)
      .frame(maxWidth: .infinity)
      .padding()
      .background(Color.gray.opacity(0.2))
      .cornerRadius(10)
  }
}
