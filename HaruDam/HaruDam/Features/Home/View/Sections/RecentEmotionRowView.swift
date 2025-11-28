//
//  RecentEmotionRowView.swift
//  HaruDam
//
//  Created by 존진 on 11/28/25.
//  Copyright © 2025 kr.co.HaruDam. All rights reserved.
//

import SwiftUI

struct RecentEmotionRowView: View {
    let emotion: EmotionRecord
    
    var body: some View {
        HStack(spacing: 16) {
            emotionIcon
            emotionInfo
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity)
        .background(rowBackground)
    }
    
    private var emotionIcon: some View {
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
    }
    
    private var emotionInfo: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(emotion.title)
                .font(.system(size: 15, weight: .semibold))
            
            Text(emotion.dateText)
                .font(.system(size: 12))
                .foregroundColor(.gray)
        }
    }
    
    private var rowBackground: some View {
        RoundedRectangle(cornerRadius: 20, style: .continuous)
            .fill(Color.white.opacity(0.95))
            .shadow(
                color: Color.black.opacity(0.02),
                radius: 12,
                x: 0,
                y: 6
            )
    }
}

#Preview {
    RecentEmotionRowView(emotion: EmotionRecord.mockData[0])
        .padding()
}
