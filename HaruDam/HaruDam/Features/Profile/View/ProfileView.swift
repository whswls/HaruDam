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
                ProfileLogoutButtonView()
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

// MARK: - 로그아웃 버튼



#Preview {
    ProfileView()
}
