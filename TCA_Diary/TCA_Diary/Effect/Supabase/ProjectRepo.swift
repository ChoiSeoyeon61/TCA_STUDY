//
//  ProjectRepo.swift
//  TCA_Diary
//
//  Created by 최서연 on 4/24/24.
//

import Foundation
import PostgREST

class ProjectRepository {
  @MainActor
  func getProject(email: String) async -> Result<ProjectDto, DiaryError> {
    return await SupaClient.shared.database
      .from("project")
      .select()
      .eq("userEmail", value: email)
      .single()
      .getDatas(type: ProjectDto.self)
  }
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
}
