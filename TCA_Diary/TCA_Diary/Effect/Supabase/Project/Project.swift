//
//  Project.swift
//  TCA_Diary
//
//  Created by 최서연 on 4/24/24.
//

import Foundation

struct Project: Equatable {
  let serverId: Int
  let userEmail: String
  let password: String
  let name: String
  let area: String
  let client: String
  let companyId: Int?
}

struct ProjectInput: Equatable, Encodable {
  let userEmail: String
  let password: String
  let name: String
  let area: String
  let client: String
  let companyId: Int?
}
