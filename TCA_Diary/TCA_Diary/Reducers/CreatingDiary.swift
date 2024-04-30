//
//  CreatingDiary.swift
//  TCA_Diary
//
//  Created by 최서연 on 4/24/24.
//

import Foundation
import ComposableArchitecture
import UIKit

@Reducer
struct CreatingDiary {
  @Dependency(\.photoPicker) var photoPicker
  
  @ObservableState
  struct State: Equatable, Identifiable {
    var id: UUID = UUID()
    var date: Date
    var title: String = ""
    var description: String = ""
    var image: UIImage?
    
    func toInput() -> DiaryInput {
      return DiaryInput(date: date, title: title, description: description)
    }
  }
  
  enum Action: BindableAction, Sendable {
    case binding(BindingAction<State>)
    case openPhotoPicker
    case selectImage(UIImage?)
    case submitDiary
  }
  
  var body: some Reducer<State, Action> {
    BindingReducer()
    
    Reduce { state, action in
      switch action {
      case .binding:
        return .none
        
      case .openPhotoPicker:
        
        return .run { send in
          do {
            let image = try await photoPicker.present()
            print(image)
            await send(.selectImage(image))
          } catch {
            print(error)
          }
        }
      case .submitDiary:
        return .none
      case .selectImage(let image):
        state.image = image
        return .none
      }
    }
  }
}
