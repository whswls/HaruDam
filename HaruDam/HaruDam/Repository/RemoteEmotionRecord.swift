//
//  RemoteEmotionRecord.swift
//  HaruDam
//
//  Created by 존진 on 1/24/26.
//  Copyright © 2026 kr.co.HaruDam. All rights reserved.
//

import Foundation

/// Supabase  emotion_records 테이블 조회 결과 DTO
struct RemoteEmotionRecord: Decodable, Identifiable {
    let id: String
    let user_id: String?
    let emotion: String?
    let title: String?
    let content: String?
    let tags: [String]?
    let created_at: String?
    let updated_at: String?
}
