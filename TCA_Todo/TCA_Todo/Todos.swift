//
//  Todos.swift
//  TCA_Todo
//
//  Created by 최서연 on 3/27/24.
//

import Foundation
import ComposableArchitecture
import SwiftUI

@Reducer
struct Todos {
  @Dependency(\.uuid) var uuid
  
  @ObservableState
  struct State: Equatable {
    var editMode: EditMode = .inactive
    var filter: Filter = .all
    var todos: IdentifiedArrayOf<Todo.State> = []
  }
  
  enum Action: Sendable {
    case addTodoButtonTapped
    case todos(IdentifiedActionOf<Todo>)
  }
  
  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .addTodoButtonTapped:
        state.todos.insert(.init(id: self.uuid()), at: 0)
        return .none
      case .todos(_):
        return .none
      }
    }
  }
}
