//
//  ProjectRepo.swift
//  TCA_Diary
//
//  Created by 최서연 on 4/24/24.
//

import Foundation
import PostgREST
import ComposableArchitecture


@DependencyClient
struct ProjectRepository {
  var getProject: (_ email: String) async -> Result<ProjectDto, DiaryError> = { _ in .failure(.error) }
  
  var createProject: (_ input: ProjectInput) async -> Result<ProjectDto, DiaryError> = { _ in .failure(.error) }
}

extension ProjectRepository: DependencyKey {
  static let liveValue = Self(
    getProject: { email in
      return await SupaClient.shared
        .from("project")
        .select()
        .eq("userEmail", value: email)
        .single()
        .getDatas(type: ProjectDto.self)
    },
    
    createProject: { input in
      do {
        return try await SupaClient.shared
          .from("project")
          .insert(input, returning: .representation)
          .single()
          .getDatas(type: ProjectDto.self)
      } catch {
        return .failure(.supaError(error))
      }
    })
}

extension DependencyValues {
  var projectRepository: ProjectRepository {
    get { self[ProjectRepository.self] }
    set { self[ProjectRepository.self] = newValue }
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
  case supaError(Error)
}
