//
//  SupaClient.swift
//  TCA_Diary
//
//  Created by 최서연 on 4/24/24.
//

import Foundation
import Supabase
import PostgREST

class SupaDiaryClient {
  static let shared = SupabaseClient(supabaseURL: URL(string: SUPA_DIARY_URL)!,
                                     supabaseKey: SUPA_DIARY_KEY)
  
  private init() {}
}

extension PostgrestBuilder {
  
  @MainActor
  func getDatas<T: Decodable>(type: T.Type) async -> Result<T, DiaryError> {
    let query = self
    do {
      let response: T = try await query.execute().value
      return .success(response)
    } catch {
      print(error, type)
      return .failure(.error)
    }
  }
}

enum DiaryError: Error {
  case error
  case supaError(Error)
}
