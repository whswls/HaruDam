//
//  SupabaseConnectionTests.swift
//  HaruDamTests
//
//  Created by 존진 on 11/11/25.
//

import XCTest
@testable import HaruDam

final class SupabaseConnectionTests: XCTestCase {
    
    func testSupabaseConnection() async throws {
        let manager = await SupabaseManager.shared
        let url = await manager.supabaseURL.appendingPathComponent("/auth/v1/settings")
        let key = await manager.supabaseKey
        
        var request = URLRequest(url: url)
        request.setValue(key, forHTTPHeaderField: "apikey")
        request.setValue("Bearer \(key)", forHTTPHeaderField: "Authorization")
        
        let (_, response) = try await URLSession.shared.data(for: request)
        let status = (response as? HTTPURLResponse)?.statusCode ?? -1
        
        XCTAssertEqual(status, 200, "Supabase 연결 실패 (status: \(status))")
    }
    
}
