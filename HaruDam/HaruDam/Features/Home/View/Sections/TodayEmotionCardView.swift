//
//  TodayEmotionCardView.swift
//  HaruDam
//
//  Created by 존진 on 11/28/25.
//  Copyright © 2025 kr.co.HaruDam. All rights reserved.
//

import SwiftUI

struct TodayEmotionCardView: View {
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                iconView
                textContent
                Spacer()
                plusIcon
            }
            .padding(20)
            .frame(maxWidth: .infinity)
            .background(cardBackground)
        }
        .buttonStyle(.plain)
    }
    
    private var iconView: some View {
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
    }
    
    private var textContent: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("오늘의 감정 담기")
                .font(.system(size: 17, weight: .semibold))
            
            Text("하루를 부드럽게 기록해보세요.")
                .font(.system(size: 13))
                .foregroundColor(.gray)
        }
    }
    
    private var plusIcon: some View {
        Image(systemName: "plus")
            .font(.system(size: 18, weight: .medium))
            .foregroundColor(AppColor.primary)
    }
    
    private var cardBackground: some View {
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
    }
}

#Preview {
    TodayEmotionCardView(onTap: {})
        .padding()
}
