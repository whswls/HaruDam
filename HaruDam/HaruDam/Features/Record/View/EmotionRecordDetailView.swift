//
//  EmotionRecordDetailView.swift
//  HaruDam
//
//  Created by 존진 on 12/2/25.
//  Copyright © 2025 kr.co.HaruDam. All rights reserved.
//

import SwiftUI

struct EmotionRecordDetailView: View {
    @Environment(\.dismiss) private var dismiss

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
                                Circle()
                                    .fill(AppColor.background)
                                    .shadow(color: Color.black.opacity(0.03), radius: 8, x: 0, y: 4)

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
                        .padding(.leading, 10)

                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 24)
                .padding(.bottom, 32)
            }
        }
        .navigationTitle("감정 기록")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .semibold))
                    }
                    .foregroundColor(AppColor.textPrimary)
                }
            }
        }
    }
}

#Preview {
    EmotionRecordDetailView(record: EmotionRecord.mockData.first!)
}
