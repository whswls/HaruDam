//
//  SupabaseManager.swift
//  HaruDam
//
//  Created by 존진 on 11/11/25.
//

import Foundation
import Supabase

final class SupabaseManager {
    static let shared = SupabaseManager()
    let client: SupabaseClient

    // Test용 public
    public let supabaseURL: URL
    public let supabaseKey: String
    
    private init() {
        guard
            let urlString = Bundle.main.object(forInfoDictionaryKey: "SUPABASE_URL") as? String,
            let key = Bundle.main.object(forInfoDictionaryKey: "SUPABASE_ANON_KEY") as? String,
            let kakaoKey = Bundle.main.object(forInfoDictionaryKey: "KAKAO_NATIVE_APP_KEY") as? String,
            let url = URL(string: urlString)
        else {
            fatalError("Supabase 환경 변수를 불러올 수 없습니다.")
        }

        self.supabaseURL = url
        self.supabaseKey = key
        self.client = SupabaseClient(supabaseURL: url, supabaseKey: key)
    }
}
