//
//  HomeView.swift
//  HaruDam
//
//  Created by 존진 on 11/24/25.
//

import SwiftUI

struct HomeView: View {
    @State private var isPresentingWriteView = false

    @StateObject private var weeklySummaryVM = WeeklyEmotionSummaryViewModel(
        repository: EmotionRecordService.shared
    )

    @StateObject private var recentEmotionVM = RecentEmotionListViewModel(
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
        .onChange(of: isPresentingWriteView) { isPresented in
            // 작성 화면이 닫히는 순간(저장 후 dismiss) 홈 데이터를 즉시 갱신
            guard isPresented == false else { return }
            Task {
                async let weekly: Void = weeklySummaryVM.loadThisWeekSummary()
                async let recent: Void = recentEmotionVM.loadRecent()
                _ = await (weekly, recent)
            }
        }
        .task {
            async let weekly: Void = weeklySummaryVM.loadThisWeekSummary()
            async let recent: Void = recentEmotionVM.loadRecent()
            _ = await (weekly, recent)
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
                RecentEmotionSection(viewModel: recentEmotionVM)
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

    @ObservedObject var viewModel: RecentEmotionListViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("최근 담은 감정")
                .font(.system(size: 15, weight: .semibold))

            content
        }
        .padding(.bottom, 16)
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle, .loading:
            HStack(spacing: 12) {
                ProgressView()
                Text("최근 기록을 불러오는 중…")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }

        case .empty:
            VStack(alignment: .leading, spacing: 6) {
                Text("최근 기록이 없어요")
                    .font(.system(size: 15, weight: .semibold))
                Text("오늘의 감정을 먼저 담아볼까요?")
                    .font(.system(size: 13))
                    .foregroundColor(.gray)
            }

        case .failed(let message):
            VStack(alignment: .leading, spacing: 6) {
                Text("최근 기록을 불러오지 못했어요")
                    .font(.system(size: 15, weight: .semibold))
                Text(message)
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                    .lineLimit(2)
            }

        case .loaded:
            VStack(spacing: 10) {
                ForEach(viewModel.items) { item in
                    RecentEmotionRow(item: item)
                }
            }
        }
    }
}

struct RecentEmotionRow: View {

    let item: RecentEmotionItem

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Text(item.emoji)
                .font(.system(size: 28))

            VStack(alignment: .leading, spacing: 6) {
                Text(item.title.isEmpty ? "(제목 없음)" : item.title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.primary)
                    .lineLimit(1)

                if item.content.isEmpty == false {
                    Text(item.content)
                        .font(.system(size: 13))
                        .foregroundColor(.gray)
                        .lineLimit(2)
                }

                Text(item.dateText)
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
            }

            Spacer(minLength: 0)
        }
        .padding(14)
        .background(rowBackground)
    }

    private var rowBackground: some View {
        RoundedRectangle(cornerRadius: 18, style: .continuous)
            .fill(Color.white.opacity(0.95))
            .shadow(
                color: Color.black.opacity(0.03),
                radius: 12,
                x: 0,
                y: 6
            )
    }
}

// MARK: - Recent Emotion ViewModel

@MainActor
final class RecentEmotionListViewModel: ObservableObject {

    enum State: Equatable {
        case idle
        case loading
        case loaded
        case empty
        case failed(String)
    }

    @Published private(set) var state: State = .idle
    @Published private(set) var items: [RecentEmotionItem] = []

    private let repository: EmotionRecordRepository
    private let calendar: Calendar
    private let isoFormatter: ISO8601DateFormatter

    init(repository: EmotionRecordRepository, calendar: Calendar = .current) {
        self.repository = repository
        self.calendar = calendar

        let f = ISO8601DateFormatter()
        f.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        self.isoFormatter = f
    }

    /// 최근 N개 기록을 로드 (기본 5개)
    /// - Note: 서버에서 최신순 + limit 적용해서 내려받아 클라이언트 가공 비용/대기 시간을 줄인다.
    func loadRecent(limit: Int = 5) async {
        state = .loading

        do {
            let rows = try await repository.fetchRecentRemoteRecords(limit: limit)

            let mapped = rows.compactMap { row -> RecentEmotionItem? in
                guard
                    let createdAtString = row.created_at,
                    let createdAt = isoFormatter.date(from: createdAtString)
                else { return nil }

                return RecentEmotionItem(
                    id: row.id,
                    emoji: normalizeEmoji(row.emotion),
                    title: row.title ?? "",
                    content: row.content ?? "",
                    createdAt: createdAt
                )
            }

            // 이미 최신순으로 내려오지만, created_at 파싱 실패/예외를 대비해 한 번 더 정렬
            items = mapped.sorted { $0.createdAt > $1.createdAt }
            state = items.isEmpty ? .empty : .loaded
        } catch {
            state = .failed(error.localizedDescription)
        }
    }

    /// 서버 emotion 값은 "😌, 😊, 😢, 😡, 😰, 🤔, 🥰, 🤯" 이모지로 온다고 가정
    /// 예외 값은 기본 🤔 처리
    private func normalizeEmoji(_ emotion: String?) -> String {
        guard let e = emotion?.trimmingCharacters(in: .whitespacesAndNewlines), e.isEmpty == false else {
            return "🤔"
        }

        switch e {
        case "😌", "😊", "😢", "😡", "😰", "🤔", "🥰", "🤯":
            return e
        default:
            return "🤔"
        }
    }
}

struct RecentEmotionItem: Identifiable, Equatable {
    let id: String
    let emoji: String
    let title: String
    let content: String
    let createdAt: Date

    var dateText: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "M/d E"
        return formatter.string(from: createdAt)
    }
}

// MARK: - Preview

#Preview {
    HomeView()
}
