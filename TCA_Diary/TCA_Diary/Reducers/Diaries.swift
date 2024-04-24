//
//  Diaries.swift
//  TCA_Diary
//
//  Created by 최서연 on 4/9/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct Diaries {

  @Dependency(\.projectRepo) var projectRepo
  
  struct State: Equatable {
    var diaries: IdentifiedArrayOf<Diary.State> = []
    var project: Project? = nil
    @PresentationState var creatingDiary: CreatingDiary.State?
    @PresentationState var selectedDiary: Diary.State?
  }
  
  enum Action: Sendable {
    case createDiaryButtonTapped
    case diaries(IdentifiedActionOf<Diary>)
    case creatingDiary(PresentationAction<CreatingDiary.Action>)
    case selectedDiary(PresentationAction<Diary.Action>)
    case getProject
    case updateProject(Project?)
  }
  
  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .createDiaryButtonTapped:
        state.creatingDiary = CreatingDiary.State(date: .now)
        return .none
        
      case let .diaries(.element(id: id, action: .openDiary)):
        let selectedDiary = state.diaries.filter { $0.id == id }.first
        print(selectedDiary)
        state.selectedDiary = selectedDiary
        return .none
        
      case .diaries:
        return .none
        
      case .creatingDiary(.presented(.submitDiary)): // 일부를 다루는 case를 위에 두어야 함
//        print(state.creatingDiary != nil)
//        guard let creatingDiary = state.creatingDiary
//        else { return .none }
//        let newDiary = Diary.State(
//
//          id: creatingDiary.date,
//          title: .now,
//          description: creatingDiary.title,
//          date: creatingDiary.description
//        )
//        state.diaries.append(newDiary)
//        state.creatingDiary = nil
        return .none
        
      case .creatingDiary: // 전체를 다루는 case는 아래에 두기
        return .none
      case .selectedDiary:
        return .none
      case .getProject:
        return .run { send in
          let result = await projectRepo.getProject(email: "ssuk5@rmr.com")
          switch result {
          case .success(let data):
            print(data)
            await send(.updateProject(data.toModel()))
          case .failure(let error):
            print(error)
            await send(.updateProject(nil))
          }
        }
      case .updateProject(let project):
        state.project = project
        return .none
      }
    }
    .forEach(\.diaries, action: \.diaries) {
      Diary()
    }
    .ifLet(\.$creatingDiary, action: \.creatingDiary) {
      CreatingDiary()
    }
    .ifLet(\.$selectedDiary, action: \.selectedDiary) {
      Diary()
    }
  }
}
