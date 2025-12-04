//
//  HomeView.swift
//  HaruDam
//
//  Created by 존진 on 11/24/25.
//

import SwiftUI

struct HomeView: View {
    
    var nickname: String = "사용자"
    @State private var isPresentingWriteView = false
    
    // TODO: 추후 ViewModel에서 관리
    private let recentEmotions: [EmotionRecord] = EmotionRecord.mockData
    private let weeklyEmotions: [CGFloat] = WeeklyEmotionChartView.mockValues
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            backgroundGradient
            scrollContent
        }
        .sheet(isPresented: $isPresentingWriteView) {
            EmotionRecordWriteView()
        }
    }
    
    // MARK: - UI Components
    
    private var backgroundGradient: some View {
        LinearGradient(
            colors: [AppColor.background],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }
    
    private var scrollContent: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 24) {
                HeaderSection(nickname: nickname)
                TodayEmotionCardView(onTap: handleTodayEmotionTap)
                WeeklyFlowSection(values: weeklyEmotions)
                RecentEmotionSection(emotions: recentEmotions)
            }
            .padding(.horizontal, 24)
            .padding(.top, 32)
            .padding(.bottom, 16)
        }
    }
    
    // MARK: - Actions
    
    private func handleTodayEmotionTap() {
        isPresentingWriteView = true
    }
}

// MARK: - Header Section

struct HeaderSection: View {
    let nickname: String
    
    private var formattedToday: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 M월 d일 EEEE"
        return formatter.string(from: Date())
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("안녕하세요 \(nickname)님")
                .font(.system(size: 28, weight: .bold))
            
            Text(formattedToday)
                .font(.system(size: 13))
                .foregroundColor(.gray)
                .padding(.leading, 3)
        }
    }
}

// MARK: - Weekly Flow Section

struct WeeklyFlowSection: View {
    let values: [CGFloat]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("이번 주 감정의 흐름")
                .font(.system(size: 15, weight: .semibold))
            
            WeeklyEmotionChartView(values: values)
                .frame(height: 160)
                .frame(maxWidth: .infinity)
                .background(chartBackground)
        }
    }
    
    private var chartBackground: some View {
        RoundedRectangle(cornerRadius: 24, style: .continuous)
            .fill(Color.white.opacity(0.95))
            .shadow(
                color: Color.black.opacity(0.03),
                radius: 16,
                x: 0,
                y: 8
            )
    }
}

// MARK: - Recent Emotion Section

struct RecentEmotionSection: View {
    let emotions: [EmotionRecord]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("최근 담은 감정")
                .font(.system(size: 15, weight: .semibold))
            
            VStack(spacing: 10) {
                ForEach(emotions) { emotion in
                    RecentEmotionRowView(emotion: emotion)
                }
            }
        }
        .padding(.bottom, 16)
    }
}

// MARK: - Preview

#Preview {
    HomeView()
}
