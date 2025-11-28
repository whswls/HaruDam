//
//  MainTabView.swift
//  HaruDam
//
//  Created by 존진 on 11/28/25.
//  Copyright © 2025 kr.co.HaruDam. All rights reserved.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // MARK: - 홈
            HomeView()
                .tabItem {
                    Image(systemName: selectedTab == 0 ? "house.fill" : "house")
                    Text("홈")
                }
                .tag(0)
            
            // MARK: - 기록
            RecordView()
                .tabItem {
                    Image(systemName: selectedTab == 1 ? "calendar.badge.clock" : "calendar")
                    Text("기록")
                }
                .tag(1)
            
            // MARK: - 프로필
            ProfileView()
                .tabItem {
                    Image(systemName: selectedTab == 2 ? "person.fill" : "person")
                    Text("프로필")
                }
                .tag(2)
        }
        .tint(AppColor.primary) // 탭 선택 색상
    }
}
