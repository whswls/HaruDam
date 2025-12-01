//
//  WeeklyEmotionChartView.swift
//  HaruDam
//
//  Created by 존진 on 11/28/25.
//  Copyright © 2025 kr.co.HaruDam. All rights reserved.
//

import SwiftUI

struct WeeklyEmotionChartView: View {
    let values: [CGFloat] // 0.0 ~ 1.0
    
    private let weekdays = ["화", "수", "목", "금", "토"]
    
    var body: some View {
        VStack {
            chartContent
            weekdayLabels
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
    }
    
    private var chartContent: some View {
        GeometryReader { geo in
            let width = geo.size.width
            let height = geo.size.height * 0.65
            let stepX = width / CGFloat(max(values.count - 1, 1))
            
            ZStack {
                baselinePath(height: height)
                emotionLinePath(width: width, height: height, stepX: stepX)
                dataPoints(height: height, stepX: stepX)
            }
        }
    }
    
    private func baselinePath(height: CGFloat) -> some View {
        VStack {
            Spacer()
            Rectangle()
                .fill(Color.gray.opacity(0.15))
                .frame(height: 1)
        }
    }
    
    private func emotionLinePath(width: CGFloat, height: CGFloat, stepX: CGFloat) -> some View {
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
    }
    
    private func dataPoints(height: CGFloat, stepX: CGFloat) -> some View {
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
    
    private var weekdayLabels: some View {
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
}

// MARK: - Mock Data

extension WeeklyEmotionChartView {
    static let mockValues: [CGFloat] = [0.4, 0.6, 0.3, 0.7, 0.5]
}

#Preview {
    WeeklyEmotionChartView(values: WeeklyEmotionChartView.mockValues)
        .frame(height: 160)
        .background(Color.white)
        .padding()
}
