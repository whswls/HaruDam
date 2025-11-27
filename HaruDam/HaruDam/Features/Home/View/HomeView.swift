//
//  HomeView.swift
//  HaruDam
//
//  Created by 존진 on 11/24/25.
//

import SwiftUI

struct EmotionRecord: Identifiable {
    let id = UUID()
    let title: String
    let dateText: String
    let iconName: String
}

struct HomeView: View {
    var nickname: String = "사용자"
    
    private var formattedToday: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 M월 d일 EEEE"
        return formatter.string(from: Date())
    }
    
    private let recentEmotions: [EmotionRecord] = [
        .init(title: "평온함", dateText: "10월 30일", iconName: "moon.stars.fill"),
        .init(title: "기쁨", dateText: "10월 29일", iconName: "sparkles")
    ]
    
    // 샘플 그래프 데이터 (월~일)
    private let weeklyEmotions: [CGFloat] = [0.4, 0.6, 0.3, 0.7, 0.5]
    
    var body: some View {
        ZStack {
            // 배경
            LinearGradient(
                colors: [ AppColor.background ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 24) {
                    headerSection
                    todayCardSection
                    weeklyFlowSection
                    recentEmotionSection
                }
                .padding(.horizontal, 24)
                .padding(.top, 32)
                .padding(.bottom, 16)
            }
        }
    }
}

// MARK: - Sections

private extension HomeView {
    
    var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("안녕하세요 \(nickname)님")
                .font(.system(size: 28, weight: .bold))
            
            Text(formattedToday)
                .font(.system(size: 13))
                .foregroundColor(.gray)
        }
    }
    
    var todayCardSection: some View {
        Button {
            // TODO: 오늘 감정 기록 화면으로 이동
        } label: {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color(red: 0.92, green: 0.96, blue: 1.0),
                                    Color(red: 0.88, green: 0.95, blue: 1.0)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 52, height: 52)
                    
                    Image(systemName: "drop.fill")
                        .font(.system(size: 22))
                        .foregroundColor(Color(red: 0.60, green: 0.75, blue: 0.95))
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("오늘의 감정 담기")
                        .font(.system(size: 17, weight: .semibold))
                    
                    Text("하루를 부드럽게 기록해보세요.")
                        .font(.system(size: 13))
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Image(systemName: "plus")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(AppColor.primary)
            }
            .padding(20)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.95),
                                Color.white.opacity(0.9)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .shadow(
                        color: Color.black.opacity(0.05),
                        radius: 16,
                        x: 0,
                        y: 8
                    )
            )
        }
        .buttonStyle(.plain)
    }
    
    var weeklyFlowSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("이번 주 감정의 흐름")
                .font(.system(size: 15, weight: .semibold))
            
            WeeklyEmotionChartView(values: weeklyEmotions)
                .frame(height: 160)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .fill(Color.white.opacity(0.95))
                        .shadow(
                            color: Color.black.opacity(0.03),
                            radius: 16,
                            x: 0,
                            y: 8
                        )
                )
        }
    }
    
    var recentEmotionSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("최근 담은 감정")
                .font(.system(size: 15, weight: .semibold))
            
            VStack(spacing: 10) {
                ForEach(recentEmotions) { emotion in
                    RecentEmotionRowView(emotion: emotion)
                }
            }
        }
        .padding(.bottom, 16)
    }
}

// MARK: - Components

struct WeeklyEmotionChartView: View {
    let values: [CGFloat] // 0.0 ~ 1.0
    
    private let weekdays = ["화", "수", "목", "금", "토"]
    
    var body: some View {
        VStack {
            GeometryReader { geo in
                let width = geo.size.width
                let height = geo.size.height * 0.65
                let stepX = width / CGFloat(max(values.count - 1, 1))
                
                ZStack {
                    // 기준선
                    VStack {
                        Spacer()
                        Rectangle()
                            .fill(Color.gray.opacity(0.15))
                            .frame(height: 1)
                    }
                    
                    // 라인 차트
                    Path { path in
                        guard let first = values.first else { return }
                        let startY = height - first * height
                        path.move(to: CGPoint(x: 0, y: startY))
                        
                        for (index, value) in values.enumerated() {
                            let x = CGFloat(index) * stepX
                            let y = height - value * height
                            path.addLine(to: CGPoint(x: x, y: y))
                        }
                    }
                    .stroke(
                        LinearGradient(
                            colors: [
                                Color(red: 0.69, green: 0.79, blue: 0.96),
                                Color(red: 0.82, green: 0.88, blue: 0.98)
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        ),
                        style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round)
                    )
                    
                    // 동그라미 포인트
                    ForEach(values.indices, id: \.self) { index in
                        let value = values[index]
                        let x = CGFloat(index) * stepX
                        let y = height - value * height
                        
                        Circle()
                            .fill(Color.white)
                            .frame(width: 10, height: 10)
                            .overlay(
                                Circle()
                                    .stroke(Color(red: 0.69, green: 0.79, blue: 0.96), lineWidth: 3)
                            )
                            .position(x: x, y: y)
                    }
                }
            }
            
            // 요일 라벨
            HStack {
                ForEach(weekdays, id: \.self) { day in
                    Spacer()
                    Text(day)
                        .font(.system(size: 11))
                        .foregroundColor(.gray)
                    Spacer()
                }
            }
            .padding(.top, 6)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
    }
}

struct RecentEmotionRowView: View {
    let emotion: EmotionRecord
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 0.96, green: 0.98, blue: 1.0),
                                Color(red: 0.93, green: 0.97, blue: 1.0)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 40, height: 40)
                
                Image(systemName: emotion.iconName)
                    .font(.system(size: 18))
                    .foregroundColor(Color(red: 0.60, green: 0.75, blue: 0.95))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(emotion.title)
                    .font(.system(size: 15, weight: .semibold))
                
                Text(emotion.dateText)
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
            }
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.white.opacity(0.95))
                .shadow(
                    color: Color.black.opacity(0.02),
                    radius: 12,
                    x: 0,
                    y: 6
                )
        )
    }
}

#Preview {
    HomeView()
}
