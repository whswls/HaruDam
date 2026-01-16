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
    let record: EmotionRecordEntity
    var formatter: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "ko_KR")
        f.dateFormat = "yyyy년 M월 d일 · EEEE"
        return f
    }()
    
    var body: some View {
        ZStack {
            AppColor.background.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    HStack(alignment: .top, spacing: 12) {
                        Text(record.emotion ?? "🙂")
                            .font(.system(size: 44))

                        VStack(alignment: .leading, spacing: 6) {
                            Text(record.title ?? "")
                                .font(.system(size: 22, weight: .semibold))
                                .foregroundColor(AppColor.textPrimary)

                            Text(formatter.string(from: record.createdAt ?? Date()))
                                .font(.system(size: 12))
                                .foregroundColor(AppColor.textSecondary)
                        }

                        Spacer()
                    }

                    Divider()

                    Text(record.content ?? "")
                        .font(.system(size: 16))
                        .foregroundColor(AppColor.textPrimary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .lineSpacing(4)

                    Spacer(minLength: 0)
                }
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.white)
                )
                .padding(.horizontal, 16)
                .padding(.top, 16)
            }
        }
        .navigationTitle("감정 기록")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - CoreData
extension EmotionRecordEntity: Identifiable {}
