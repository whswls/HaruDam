//
//  EmotionRecord.swift
//  HaruDam
//
//  Created by 존진 on 11/28/25.
//  Copyright © 2025 kr.co.HaruDam. All rights reserved.
//

import Foundation

struct EmotionRecord: Identifiable {
    let id = UUID()
    let title: String
    let date: Date
    let iconName: String
    
    var dateText: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "M월 d일"
        return formatter.string(from: date)
    }
}

// MARK: - Mock Data

extension EmotionRecord {
    static let mockData: [EmotionRecord] = [
        .init(
            title: "평온함",
            date: Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date(),
            iconName: "moon.stars.fill"
        ),
        .init(
            title: "기쁨",
            date: Calendar.current.date(byAdding: .day, value: -2, to: Date()) ?? Date(),
            iconName: "sparkles"
        )
    ]
}
