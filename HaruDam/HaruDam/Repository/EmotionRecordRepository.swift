//
//  EmotionRecordRepository.swift
//  HaruDam
//
//  Created by 존진 on 1/24/26.
//  Copyright © 2026 kr.co.HaruDam. All rights reserved.
//

import Foundation

// 감정 기록 데이터 정의하는 프로토콜
protocol EmotionRecordRepository {
    
    // Supabase에서 기간 범위로 감정 기록을 조회
    func fetchRemoteRecords(from start: Date, to end: Date) async throws -> [RemoteEmotionRecord]
    
    // Supabase - insert 생성된 서버 id를 반환
    func insert(record: EmotionRecordEntity) async throws -> String
    
    // Supabase - update
    func update(record: EmotionRecordEntity) async throws
    
    // Supabase - delete
    func delete(recordId: String) async throws
    func delete(record: EmotionRecordEntity) async throws
}
