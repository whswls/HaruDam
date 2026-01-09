//
//  ProfileHeaderCardView.swift
//  HaruDam
//
//  Created by 존진 on 12/8/25.
//  Copyright © 2025 kr.co.HaruDam. All rights reserved.
//

import SwiftUI

struct ProfileHeaderCardView: View {
    
    @EnvironmentObject private var authStore: AuthStore
    
    let email: String = "user@example.com"
    
    let totalRecords: Int = 45
    let streakDays: Int = 7
    let moodSummary: String = "자주 담은 감정"
    let moodDescription: String = "평온함"
    
    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            
            HStack(alignment: .center, spacing: 16) {
                // 아바타
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.7))
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: "person.fill")
                        .font(.system(size: 26, weight: .medium))
                        .foregroundColor(Color(red: 0.47, green: 0.70, blue: 0.93))
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(authStore.displayUserName)
                        .font(.headline)
                    
                    Text(email)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            
            // 통계 3개 카드
            HStack(spacing: 10) {
                ProfileStatItemView(
                    iconName: "drop.fill",
                    iconColor: Color.blue.opacity(0.7),
                    title: "총 기록",
                    value: "\(totalRecords)"
                )
                
                ProfileStatItemView(
                    iconName: "calendar",
                    iconColor: Color.green.opacity(0.7),
                    title: "연속 기록",
                    value: "\(streakDays)일"
                )
                
                ProfileStatItemView(
                    iconName: "heart",
                    iconColor: Color.pink.opacity(0.7),
                    title: moodSummary,
                    value: moodDescription
                )
            }
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.90, green: 0.96, blue: 1.0),
                            Color(red: 0.93, green: 0.98, blue: 0.97)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 6)
        )
    }
}

struct ProfileStatItemView: View {
    let iconName: String
    let iconColor: Color
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: iconName)
                .font(.system(size: 18))
                .foregroundColor(iconColor)
                .frame(width: 32, height: 32)
                .background(
                    Circle()
                        .fill(iconColor.opacity(0.12))
                )
            
            Text(value)
                .font(.subheadline.bold())
                .foregroundColor(.primary)
            
            Text(title)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.white.opacity(0.85))
        )
    }
}

#Preview {
    ProfileHeaderCardView()
}
