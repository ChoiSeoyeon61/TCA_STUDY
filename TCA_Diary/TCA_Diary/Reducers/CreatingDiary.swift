//
//  CreatingDiary.swift
//  TCA_Diary
//
//  Created by 최서연 on 4/24/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct CreatingDiary {
  
  @ObservableState
  struct State: Equatable, Identifiable {
    var id: UUID = UUID()
    var date: Date
    var title: String = ""
    var description: String = ""
    
    func toInput() -> DiaryInput {
      return DiaryInput(date: date, title: title, description: description)
    }
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
