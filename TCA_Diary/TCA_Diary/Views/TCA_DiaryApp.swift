//
//  TCA_DiaryApp.swift
//  TCA_Diary
//
//  Created by 최서연 on 4/9/24.
//

import SwiftUI
import ComposableArchitecture

@main
struct TCA_DiaryApp: App {
  
  var body: some Scene {
    WindowGroup {
      DiariesView(store: Store(initialState: Diaries.State(), reducer: {
        Diaries()
      }))
    }
  }
}
