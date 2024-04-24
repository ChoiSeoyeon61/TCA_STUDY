//
//  SupaClient.swift
//  TCA_Diary
//
//  Created by 최서연 on 4/24/24.
//

import Foundation
import Supabase

class SupaClient {
  static let shared = SupabaseClient(supabaseURL: URL(string: SUPA_URL)!,
                                     supabaseKey: SUPA_KEY)
  
  private init() {}
}
