//
//  Diary.swift
//  TCA_Diary
//
//  Created by 최서연 on 4/9/24.
//

import Foundation
import ComposableArchitecture
import SwiftUI

@Reducer
struct Diary {
  @Dependency(\.dismiss) var dismiss
  
  @ObservableState
  struct State: Equatable, Identifiable {
    var id: Int
    var title: String
    var description: String
    var date: Date
    var createdAt: Date
    
    var editMode: EditMode = .inactive
  }
  
  enum Action: BindableAction, Sendable {
    case binding(BindingAction<State>)
    case submitDiary
    case openDiary
    case toggleEditMode
  }
  
  var body: some Reducer<State, Action> {
    BindingReducer()
    
    Reduce { state, action in
      switch action {
      case .binding:
        return .none
        
      case .submitDiary:
        print(state)
        
        return .none
      case .openDiary:
        return .none
      case .toggleEditMode:
        return .none
      }
    }
  }
}

@Reducer
struct CreatingDiary {
  
  @ObservableState
  struct State: Equatable, Identifiable {
    var id: UUID = UUID()
    var date: Date
    var title: String = ""
    var description: String = ""
  }
  
  enum Action: BindableAction, Sendable {
    case binding(BindingAction<State>)
    case submitDiary
  }
  
  var body: some Reducer<State, Action> {
    BindingReducer()
    
    Reduce { state, action in
      switch action {
      case .binding:
        return .none
        
      case .submitDiary:
        return .none
      }
    }
  }
}
