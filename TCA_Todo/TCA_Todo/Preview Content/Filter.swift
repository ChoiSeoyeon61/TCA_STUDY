//
//  Filter.swift
//  TCA_Todo
//
//  Created by 최서연 on 3/27/24.
//

import Foundation
import SwiftUI

enum Filter: LocalizedStringKey, CaseIterable, Hashable {
  case all = "All"
  case active = "Active"
  case completed = "Completed"
}
