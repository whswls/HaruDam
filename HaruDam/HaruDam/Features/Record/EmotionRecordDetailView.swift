//
//  EmotionRecordDetailView.swift
//  HaruDam
//
//  Created by 존진 on 12/2/25.
//  Copyright © 2025 kr.co.HaruDam. All rights reserved.
//

import SwiftUI

struct EmotionRecordDetailView: View {

    let record: EmotionRecord
    private var formatter: DateFormatter = .init()

    init(record: EmotionRecord) {
        self.record = record
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 M월 d일 · EEEE"
    }

    var body: some View {
        ZStack {
            AppColor.background.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    // 제목 및 날짜
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(spacing: 12) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 18)
                                    .fill(Color.white)

                                Text(record.emoji)
                                    .font(.system(size: 32))
                            }
                            .frame(width: 64, height: 64)

                            VStack(alignment: .leading, spacing: 4) {
                                Text(record.title)
                                    .font(.system(size: 22, weight: .bold))
                                    .foregroundColor(AppColor.textPrimary)

                                Text(formatter.string(from: record.date))
                                    .font(.system(size: 13))
                                    .foregroundColor(AppColor.textSecondary)
                            }
                        }
                    }

                    // 내용
                    Text(record.description)
                        .font(.system(size: 15))
                        .foregroundColor(AppColor.textPrimary)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 24)
                .padding(.bottom, 32)
            }
        }
        .navigationTitle("감정 기록")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    EmotionRecordDetailView(record: EmotionRecord.mockData.first!)
}
