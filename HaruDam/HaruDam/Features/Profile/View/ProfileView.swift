//
//  ProfileView.swift
//  HaruDam
//
//  Created by 존진 on 11/28/25.
//  Copyright © 2025 kr.co.HaruDam. All rights reserved.
//

import SwiftUI

struct ProfileView: View {
    // MARK: - 임시 상태 (나중에 ViewModel로 대체)
    @State private var isNotificationOn: Bool = true
    @State private var isDarkModeOn: Bool = false
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 24) {
                
                // 상단 타이틀
                Text("프로필")
                    .font(.system(size: 28, weight: .bold))
                    .padding(.top, 8)
                
                // 프로필 카드
                ProfileHeaderCardView()
                
                // 알림 설정
                VStack(alignment: .leading, spacing: 12) {
                    Text("알림 설정")
                        .font(.headline)
                    
                    NotificationCardView(isOn: $isNotificationOn)
                }
                
                // 앱 설정
                VStack(alignment: .leading, spacing: 12) {
                    Text("앱 설정")
                        .font(.headline)
                    
                    VStack(spacing: 0) {
                        SettingRowToggleView(
                            iconSystemName: "moon",
                            iconBackground: Color.green.opacity(0.12),
                            title: "다크 모드",
                            isOn: $isDarkModeOn
                        )
                        
                        Divider()
                            .frame(maxWidth: 362)
                        
                        SettingRowNavigationView(
                            iconSystemName: "lock",
                            iconBackground: Color.pink.opacity(0.12),
                            title: "개인정보 보호",
                            action: {
                                // 개인정보 보호 화면 이동 예정
                            }
                        )
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white)
                            .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
                    )
                }
                
                // 지원 섹션
                VStack(alignment: .leading, spacing: 12) {
                    Text("지원")
                        .font(.headline)
                    
                    VStack(spacing: 0) {
                        SettingRowNavigationView(
                            iconSystemName: "questionmark.circle",
                            iconBackground: Color.orange.opacity(0.12),
                            title: "도움말",
                            action: {
                                // 도움말 화면 이동 예정
                            }
                        )
                        
                        Divider()
                            .frame(maxWidth: 362)
                        
                        SettingRowNavigationView(
                            iconSystemName: "envelope",
                            iconBackground: Color.yellow.opacity(0.12),
                            title: "문의하기",
                            action: {
                                // 문의하기 화면 이동 예정
                            }
                        )
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white)
                            .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
                    )
                }
                
                // 로그아웃 버튼
                LogoutButtonView()
                    .padding(.top, 8)
                
                // 하단 버전 정보
                VStack(spacing: 4) {
                    Text("하루담 v1.0.0")
                        .font(.footnote)
                        .foregroundColor(AppColor.textSecondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 8)
                .padding(.bottom, 32)
            }
            .padding(.horizontal, 20)
        }
        .background(
            AppColor.background.ignoresSafeArea()
        )
    }
}

// MARK: - 프로필 헤더 카드

struct ProfileHeaderCardView: View {
    // TODO: 나중에 ViewModel에서 주입
    let nickname: String = "감정 기록자"
    let email: String = "user@example.com"
    
    let totalRecords: Int = 45
    let streakDays: Int = 7
    let moodSummary: String = "평온함"
    let moodDescription: String = "자주 담은 감정"
    
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
                    Text(nickname)
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

// MARK: - 알림 설정

struct NotificationCardView: View {
    @Binding var isOn: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color.blue.opacity(0.10))
                    .frame(width: 36, height: 36)
                
                Image(systemName: "bell")
                    .font(.system(size: 16))
                    .foregroundColor(Color.blue)
            }
            
            Text("알림 받기")
                .font(.system(size: 16))
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .labelsHidden()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
        )
    }
}

// MARK: - 앱 설정

struct SettingRowToggleView: View {
    let iconSystemName: String
    let iconBackground: Color
    let title: String
    @Binding var isOn: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(iconBackground)
                    .frame(width: 36, height: 36)
                
                Image(systemName: iconSystemName)
                    .font(.system(size: 16))
                    .foregroundColor(.primary)
            }
            
            Text(title)
                .font(.system(size: 16))
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .labelsHidden()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
    }
}

// MARK: - 설정 행 (네비게이션)

struct SettingRowNavigationView: View {
    let iconSystemName: String
    let iconBackground: Color
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(iconBackground)
                        .frame(width: 36, height: 36)
                    
                    Image(systemName: iconSystemName)
                        .font(.system(size: 16))
                        .foregroundColor(.primary)
                }
                
                Text(title)
                    .font(.system(size: 16))
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - 로그아웃 버튼

struct LogoutButtonView: View {
    var body: some View {
        Button {
            // 로그아웃 로직 연결 예정
        } label: {
            HStack(spacing: 8) {
                Image(systemName: "arrow.right.square")
                    .font(.system(size: 16, weight: .semibold))
                
                Text("로그아웃")
                    .font(.system(size: 16, weight: .semibold))
            }
            .foregroundColor(Color.red.opacity(0.8))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(Color.red.opacity(0.4), lineWidth: 1)
                    .background(
                        RoundedRectangle(cornerRadius: 18)
                            .fill(Color.red.opacity(0.04))
                    )
            )
        }
    }
}

#Preview {
    ProfileView()
}
