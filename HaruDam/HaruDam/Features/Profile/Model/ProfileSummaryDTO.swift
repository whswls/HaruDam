//
//  ProfileSummary.swift
//  HaruDam
//
//  Created by 존진 on 1/29/26.
//  Copyright © 2026 kr.co.HaruDam. All rights reserved.
//

import Foundation

struct ProfileSummaryDTO: Decodable {
    let totalRecords: Int
    let streakDays: Int
    let mostFrequentEmotion: String
    
    enum CodingKeys: String, CodingKey {
        case totalRecords = "total_records"
        case streakDays = "streak_days"
        case mostFrequentEmotion = "most_frequent_emotion"
    }
}
