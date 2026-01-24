//
//  HomeView.swift
//  HaruDam
//
//  Created by 존진 on 11/24/25.
//

import SwiftUI

struct HomeView: View {
    
    @State private var isPresentingWriteView = false
    
    // TODO: 추후 ViewModel에서 관리
    private let recentEmotions: [EmotionRecord] = EmotionRecord.mockData

    @StateObject private var weeklySummaryVM = WeeklyEmotionSummaryViewModel(
        repository: EmotionRecordService.shared
    )
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            backgroundGradient
            scrollContent
        }
        .sheet(isPresented: $isPresentingWriteView) {
            EmotionRecordWriteView()
        }
        .task {
            await weeklySummaryVM.loadThisWeekSummary()
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
                HeaderSection()
                TodayEmotionCardView(onTap: handleTodayEmotionTap)
                WeeklySummarySection(viewModel: weeklySummaryVM)
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
    
    @EnvironmentObject private var authStore: AuthStore
    
    private var formattedToday: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 M월 d일 EEEE"
        return formatter.string(from: Date())
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("안녕하세요 \(authStore.displayUserName)님")
                .font(.system(size: 28, weight: .bold))
            
            Text(formattedToday)
                .font(.system(size: 13))
                .foregroundColor(.gray)
                .padding(.leading, 3)
        }
    }
}

// MARK: - Weekly Summary Section

struct WeeklySummarySection: View {

    @ObservedObject var viewModel: WeeklyEmotionSummaryViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("이번 주 감정 요약")
                .font(.system(size: 15, weight: .semibold))

            WeeklyEmotionSummaryCard(state: viewModel.state, summary: viewModel.summary)
        }
    }
}

struct WeeklyEmotionSummaryCard: View {

    let state: WeeklyEmotionSummaryViewModel.State
    let summary: WeeklyEmotionSummary?

    var body: some View {
        content
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(18)
            .background(cardBackground)
    }

    @ViewBuilder
    private var content: some View {
        switch state {
        case .idle, .loading:
            HStack(spacing: 12) {
                ProgressView()
                Text("이번 주 감정을 불러오는 중…")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }

        case .empty:
            VStack(alignment: .leading, spacing: 6) {
                Text("이번 주 기록이 아직 없어요")
                    .font(.system(size: 15, weight: .semibold))
                Text("오늘의 감정을 먼저 담아볼까요?")
                    .font(.system(size: 13))
                    .foregroundColor(.gray)
            }

        case .failed(let message):
            VStack(alignment: .leading, spacing: 6) {
                Text("요약을 불러오지 못했어요")
                    .font(.system(size: 15, weight: .semibold))
                Text(message)
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                    .lineLimit(2)
            }

        case .loaded:
            if let summary {
                HStack(alignment: .top, spacing: 12) {
                    Text(summary.emoji)
                        .font(.system(size: 38))

                    VStack(alignment: .leading, spacing: 6) {
                        Text(summary.title)
                            .font(.system(size: 16, weight: .semibold))

                        Text(summary.description)
                            .font(.system(size: 13))
                            .foregroundColor(.gray)
                            .lineLimit(2)

                        Text("기록한 날: \(summary.recordedDays)일")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                            .padding(.top, 2)
                    }

                    Spacer(minLength: 0)
                }
            } else {
                // loaded인데 summary가 없는 경우는 방어 처리
                Text("요약 정보가 없어요")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
        }
    }

    private var cardBackground: some View {
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
