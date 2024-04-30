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

  @Reducer(state: .equatable)
  enum Destination {
    case creating(CreatingDiary)
    case select(Diary)
  }
  
  @Dependency(\.diaryRepo) var diaryRepo
  
  @ObservableState
  struct State: Equatable {
    var diaries: IdentifiedArrayOf<Diary.State> = []
    var destination = StackState<Destination.State>()
  }
  
  enum Action: Sendable {
    case createDiaryButtonTapped
    case diaries(IdentifiedActionOf<Diary>)
    case destination(StackAction<Destination.State, Destination.Action>)
    case refreshDiaries
    case showCreateDiaryFailed
    case getDiaries
    case fetchDiaries(Result<[DiaryDto], DiaryError>)
    case clearCreatingDiary
    case openDiary(Diary.State)
  }
  
  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .createDiaryButtonTapped:
        state.destination = .creating(CreatingDiary.State(date: .now))
        return .none
        
      case let .diaries(.element(id: id, action: .openDiary)):
        guard let selectedDiary = state.diaries.filter({ $0.id == id }).first else {
          return .none
        }
        
        return .run { send in
          await send(.openDiary(selectedDiary))
        }
        
      case .openDiary(let diary):
        state.destination = .select(diary)
        return .none
        
      case .diaries:
        return .none
        
      case .destination(.presented(.creating(.submitDiary))): // 일부를 다루는 case를 위에 두어야 함
        switch state.destination {
        case let .creating(creatingDiary):
          return .run { send in
            let input = creatingDiary.toInput()
            let result = await diaryRepo.createDiary(input: input)
            switch result {
            case .success(let data):
              await send(.clearCreatingDiary)
              await send(.refreshDiaries)
              let diary = data.toModel()
              await send(.openDiary(diary))
            case .failure(let error):
              await send(.clearCreatingDiary)
              await send(.showCreateDiaryFailed)
            }
          }
        default:
          return .none
        }
        
        
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
        state.destination.pop
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
      case .destination:
        return .none
      }
    }
    .forEach(\.diaries, action: \.diaries) {
      Diary()
    }
    .forEach(\.destination, action: \.destination)
  }
  
  
}
