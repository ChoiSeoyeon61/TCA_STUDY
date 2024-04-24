//
//  ProjectDto.swift
//  TCA_Diary
//
//  Created by 최서연 on 4/24/24.
//

import Foundation

struct ProjectDto: Decodable {
  let id: Int?
  let userEmail: String?
  let password: String?
  let name: String?
  let area: String?
  let client: String?
  let companyId: Int?
  
  func toModel() -> Project {
    return Project(serverId: id ?? "",
                   userEmail: userEmail ?? "",
                   password: password ?? "",
                   name: name ?? "",
                   area: area ?? "",
                   client: client ?? "",
                   companyId: companyId ?? -1)
  }
}
