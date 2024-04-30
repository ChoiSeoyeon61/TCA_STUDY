//
//  DiaryDto.swift
//  TCA_Diary
//
//  Created by 최서연 on 4/24/24.
//

import Foundation

struct DiaryDto: Decodable {
  let id: Int?
  let title: String?
  let description: String?
  let date: Date?
  let createdAt: Date?
  
  func toModel() -> Diary.State {
    return Diary.State(
      id: id ?? -1,
      title: title ?? "",
      description: description ?? "",
      date: date ?? .now,
      createdAt: createdAt ?? .now
    )
  }
}
