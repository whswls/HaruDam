//
//  WeeklyEmotionSummaryViewModel.swift
//  HaruDam
//
//  Created by 존진 on 1/24/26.
//  Copyright © 2026 kr.co.HaruDam. All rights reserved.
//

import Foundation

@MainActor
final class WeeklyEmotionSummaryViewModel: ObservableObject {

    enum State: Equatable {
        case idle
        case loading
        case loaded
        case empty
        case failed(String)
    }

    @Published private(set) var state: State = .idle
    @Published private(set) var summary: WeeklyEmotionSummary?

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

    /// 홈 화면 진입 시 호출
    func loadThisWeekSummary() async {
        state = .loading

        do {
            let (start, end) = makeThisWeekRange()
            let rows = try await repository.fetchRemoteRecords(from: start, to: end)

            guard rows.isEmpty == false else {
                summary = nil
                state = .empty
                return
            }

            summary = buildSummary(from: rows, start: start, end: end)
            state = .loaded
        } catch {
            state = .failed(error.localizedDescription)
        }
    }
}

// MARK: - Summary Builder

@MainActor
private extension WeeklyEmotionSummaryViewModel {

    // 이번 주(월~일) 날짜 범위
    func makeThisWeekRange() -> (Date, Date) {
        var cal = calendar
        cal.firstWeekday = 2 // 월요일 시작

        let today = cal.startOfDay(for: Date())
        let weekday = cal.component(.weekday, from: today)
        let diff = (weekday - cal.firstWeekday + 7) % 7

        let startOfWeek = cal.date(byAdding: .day, value: -diff, to: today)!
        let endExclusive = cal.date(byAdding: .day, value: 7, to: startOfWeek)!

        return (startOfWeek, endExclusive)
    }

    func buildSummary(from rows: [RemoteEmotionRecord], start: Date, end: Date) -> WeeklyEmotionSummary {
        // 날짜별 마지막 감정(가장 최신 created_at) 1개만 반영해서 기록 일수/대표 감정을 안정적으로 계산
        var latestByDay: [Date: (score: Int, createdAt: Date)] = [:]

        for row in rows {
            guard
                let createdAtString = row.created_at,
                let createdAt = isoFormatter.date(from: createdAtString)
            else { continue }

            let day = calendar.startOfDay(for: createdAt)
            let score = score(from: row.emotion)

            if let existing = latestByDay[day] {
                if createdAt > existing.createdAt {
                    latestByDay[day] = (score: score, createdAt: createdAt)
                }
            } else {
                latestByDay[day] = (score: score, createdAt: createdAt)
            }
        }

        let dayScores = latestByDay.values.map { $0.score }
        let recordedDays = dayScores.count

        // fallback: 파싱 실패로 dayScores가 비었으면 rows 기준으로 계산
        let safeScores: [Int] = dayScores.isEmpty ? rows.map { score(from: $0.emotion) } : dayScores

        let avgScore = max(1, min(5, Int(round(Double(safeScores.reduce(0, +)) / Double(max(1, safeScores.count))))))
        let mostCommonScore = mostFrequentScore(in: safeScores) ?? avgScore

        return WeeklyEmotionSummary(
            emoji: emoji(for: mostCommonScore),
            title: titleText(for: avgScore),
            description: descriptionText(for: avgScore, recordedDays: recordedDays),
            recordedDays: recordedDays
        )
    }

    func mostFrequentScore(in scores: [Int]) -> Int? {
        guard scores.isEmpty == false else { return nil }
        let grouped = Dictionary(grouping: scores, by: { $0 })
        return grouped.max { $0.value.count < $1.value.count }?.key
    }

    /// emotion(String?) → score(1~5)
    /// 기준:
    /// 5: 매우 긍정 (🥰)
    /// 4: 긍정 (😊, 😌)
    /// 3: 중립/사색 (🤔)
    /// 2: 불안/부정 (😰, 😡)
    /// 1: 매우 부정 (😢, 🤯)
    func score(from emotion: String?) -> Int {
        guard let e = emotion?.trimmingCharacters(in: .whitespacesAndNewlines), e.isEmpty == false else {
            return 3
        }

        switch e {
        case "🥰": return 5
        case "😊", "😌": return 4
        case "🤔": return 3
        case "😰", "😡": return 2
        case "😢", "🤯": return 1
        default: return 3
        }
    }

    func emoji(for score: Int) -> String {
        switch score {
        case 5: return "🥰"
        case 4: return "😊"
        case 3: return "🤔"
        case 2: return "😰"
        case 1: return "😢"
        default: return "🤔"
        }
    }

    func titleText(for avg: Int) -> String {
        switch avg {
        case 4...5:
            return "꽤 좋은 한 주였어요"
        case 3:
            return "무난한 한 주였어요"
        default:
            return "조금 힘든 한 주였어요"
        }
    }

    func descriptionText(for avg: Int, recordedDays: Int) -> String {
        // 기록 일수에 따라 톤만 살짝 보정
        let daysText = recordedDays == 0 ? "" : "(기록 \(recordedDays)일) "

        switch avg {
        case 4...5:
            return daysText + "기분 좋은 날이 많았네요"
        case 3:
            return daysText + "큰 기복 없이 지나갔어요"
        default:
            return daysText + "스스로를 조금 더 챙겨줘도 좋아요"
        }
    }
}
