//
//  DiaryRepo.swift
//  TCA_Diary
//
//  Created by 최서연 on 4/24/24.
//

import ComposableArchitecture
import Foundation

@DependencyClient
struct DiaryRepo {
  var getDiaries: () async -> Result<[DiaryDto], DiaryError> = { .failure(.error) }

  var getDiary: (_ id: Int) async -> Result<DiaryDto, DiaryError> = { _ in .failure(.error) }

  var createDiary: (_ input: DiaryInput) async -> Result<DiaryDto, DiaryError> = { _ in .failure(.error) }

  var updateDiary: (_ input: DiaryInput) async -> Result<DiaryDto, DiaryError> = { _ in .failure(.error) }
}

extension DiaryRepo: DependencyKey {
  static let liveValue = Self(
    getDiaries: {
      await SupaDiaryClient.shared
        .from("diary")
        .select()
        .getDatas(type: [DiaryDto].self)
    },

    getDiary: { id in
      await SupaDiaryClient.shared
        .from("diary")
        .select()
        .eq("id", value: id)
        .single()
        .getDatas(type: DiaryDto.self)
    },

    createDiary: { input in
      do {
        return try await SupaDiaryClient.shared
          .from("diary")
          .insert(input, returning: .representation)
          .select()
          .single()
          .getDatas(type: DiaryDto.self)
      } catch {
        return .failure(.supaError(error))
      }
    },

    updateDiary: { input in
      do {
        return try await SupaDiaryClient.shared
          .from("diary")
          .update(input, returning: .representation)
          .select()
          .single()
          .getDatas(type: DiaryDto.self)
      } catch {
        return .failure(.supaError(error))
      }
    })
}

struct DiaryInput: Equatable, Encodable {
  let date: Date
  let title: String
  let description: String
}

extension DependencyValues {
  var diaryRepo: DiaryRepo {
    get { self[DiaryRepo.self] }
    set { self[DiaryRepo.self] = newValue }
  }
}
