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

  @Dependency(\.diaryRepo) var diaryRepo
  
  struct State: Equatable {
    var diaries: IdentifiedArrayOf<Diary.State> = []
    @PresentationState var creatingDiary: CreatingDiary.State?
    @PresentationState var selectedDiary: Diary.State?
  }
  
  enum Action: Sendable {
    case createDiaryButtonTapped
    case diaries(IdentifiedActionOf<Diary>)
    case creatingDiary(PresentationAction<CreatingDiary.Action>)
    case selectedDiary(PresentationAction<Diary.Action>)
    case refreshDiaries
    case showCreateDiaryFailed
    case getDiaries
    case fetchDiaries(Result<[DiaryDto], DiaryError>)
    case clearCreatingDiary
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
        guard let creatingDiary = state.creatingDiary
        else { return .none }
        return .run { send in
          let input = creatingDiary.toInput()
          let result = await diaryRepo.createDiary(input: input)
          switch result {
          case .success(let data):
            await send(.clearCreatingDiary)
            await send(.refreshDiaries)
          case .failure(let error):
            await send(.clearCreatingDiary)
            await send(.showCreateDiaryFailed)
          }
        }
        
        return .none
        
      case .creatingDiary: // 전체를 다루는 case는 아래에 두기
        return .none
      case .selectedDiary:
        return .none
        
      case .refreshDiaries:
        return .none
      case .showCreateDiaryFailed:
        return .none
      case .getDiaries:
        return .run { send in
          let result = await diaryRepo.getDiaries()
          await send(.fetchDiaries(result))
        }
      case .clearCreatingDiary:
        state.creatingDiary = nil
        return .none
      case .fetchDiaries(let result):
        switch result {
        case .success(let data):
          print(data)
          let diaries = data.map { $0.toModel() }
          state.diaries = .init(uniqueElements: diaries)
        case .failure(let error):
          print(error)
        }
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
