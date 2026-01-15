//
//  RecordView.swift
//  HaruDam
//
//  Created by 존진 on 11/28/25.
//  Copyright © 2025 kr.co.HaruDam. All rights reserved.
//

import SwiftUI
import CoreData

// MARK: - View
struct RecordView: View {

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \EmotionRecordEntity.createdAt, ascending: false)],
        animation: .default
    )
    private var records: FetchedResults<EmotionRecordEntity>

    private var monthlyRecordedDays: Int {
        let calendar = Calendar.current
        let now = Date()
        guard let monthInterval = calendar.dateInterval(of: .month, for: now) else { return 0 }

        // 이번 달에 기록된 날짜(일) 단위로 중복 제거
        let days = records
            .compactMap { $0.createdAt }
            .filter { monthInterval.contains($0) }
            .map { calendar.startOfDay(for: $0) }

        return Set(days).count
    }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                AppColor.background.ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 24) {
                        headerSection
                        summarySection
                        recordsSection
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 32)
                    .padding(.bottom, 24)
                }
            }
        }
    }

    // MARK: - Sections

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("감정 기록")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(AppColor.textPrimary)

            Text("지금까지 담은 감정들")
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(AppColor.textSecondary)
        }
        .padding(.leading, 5)
    }

    private var summarySection: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(AppColor.background)
                    .frame(width: 58, height: 58)
                
                Image(systemName: "calendar")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(AppColor.primary)
            }
            .frame(width: 64, height: 64)

            VStack(alignment: .leading, spacing: 6) {
                Text("이번 달")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(AppColor.textPrimary)

                Text("\(monthlyRecordedDays)일 기록됨")
                    .font(.system(size: 13, weight: .regular))
                    .foregroundColor(AppColor.textSecondary)
            }

            Spacer()

            VStack(alignment: .trailing) {
                Text("\(monthlyRecordedDays)")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(AppColor.primary)

                Text("days")
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(AppColor.textSecondary)
                    .padding(.trailing, 3)
            }
        }
        .padding(20)
        .background(
                RoundedRectangle(cornerRadius: 28)
                    .fill(AppColor.primary.opacity(0.08))
                    .background(
                        RoundedRectangle(cornerRadius: 28)
                            .stroke(AppColor.primary.opacity(0.08), lineWidth: 1)
                    )
            )
        .shadow(color: Color.black.opacity(0.03), radius: 10, x: 0, y: 6)
    }

    private var recordsSection: some View {
        VStack(spacing: 14) {
            ForEach(records) { record in
                NavigationLink {
                    EmotionRecordDetailView()
                } label: {
                    EmotionRecordRow(record: record)
                }
                .buttonStyle(.plain)
            }
        }
    }
}

// MARK: - Row

struct EmotionRecordRow: View {

    let record: EmotionRecordEntity
    private var formatter: DateFormatter = .init()
    
    init(record: EmotionRecordEntity) {
            self.record = record
            formatter.locale = Locale(identifier: "ko_KR")
            formatter.dateFormat = "yyyy년 M월 d일 · EEEE"
        }

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            ZStack {
                Circle()
                    .fill(AppColor.background)
                    .shadow(color: Color.black.opacity(0.03), radius: 8, x: 0, y: 4)

                Text(record.emotion ?? "🙂")
                    .font(.system(size: 28))
            }
            .frame(width: 56, height: 56)

            VStack(alignment: .leading, spacing: 6) {
                Text(record.title ?? "")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(AppColor.textPrimary)

                Text(formatter.string(from: record.createdAt ?? Date()))
                    .font(.system(size: 12))
                    .foregroundColor(AppColor.textSecondary)

                Text(record.content ?? "")
                    .font(.system(size: 13))
                    .foregroundColor(AppColor.textSecondary)
                    .lineLimit(2)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(AppColor.textSecondary)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.white.opacity(0.95))
        )
        .shadow(color: Color.black.opacity(0.02), radius: 8, x: 0, y: 4)
    }
}



#Preview {
    RecordView()
}
