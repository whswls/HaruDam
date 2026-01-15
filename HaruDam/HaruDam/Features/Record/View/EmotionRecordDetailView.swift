//
//  EmotionRecordDetailView.swift
//  HaruDam
//
//  Created by 존진 on 12/2/25.
//  Copyright © 2025 kr.co.HaruDam. All rights reserved.
//

import SwiftUI
import CoreData

struct EmotionRecordDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @FetchRequest(
        sortDescriptors: [
            NSSortDescriptor(keyPath: \EmotionRecordEntity.createdAt, ascending: false)
        ],
        animation: .default
    )
    private var records: FetchedResults<EmotionRecordEntity>
    private var formatter: DateFormatter = .init()
    
    //    init(record: EmotionRecord) {
    //        formatter.locale = Locale(identifier: "ko_KR")
    //        formatter.dateFormat = "yyyy년 M월 d일 · EEEE"
    //    }
    
    var body: some View {
        ZStack {
            AppColor.background.ignoresSafeArea()
            
            List {
                if records.isEmpty {
                    Text("아직 감정 기록이 없어요.")
                        .foregroundColor(.secondary)
                } else {
                    ForEach(records) { record in
                        VStack(alignment: .leading, spacing: 6) {
                            HStack(spacing: 8) {
                                Text(record.emotion ?? "🙂")
                                    .font(.system(size: 24))
                                
                                Text(record.title ?? "")
                                    .font(.system(size: 16, weight: .semibold))
                            }
                            
                            Text(record.content ?? "")
                                .font(.system(size: 14))
                                .foregroundColor(.secondary)
                                .lineLimit(2)
                            
                            Text(
                                (record.createdAt ?? Date())
                                    .formatted(date: .abbreviated, time: .omitted)
                            )
                            .font(.caption)
                            .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 6)
                    }
                }
            }
            .navigationTitle("감정 기록")
        }
    }
}

// MARK: - CoreData
extension EmotionRecordEntity: Identifiable {}
