//
//  RootView.swift
//  HaruDam
//
//  Created by 존진 on 12/18/25.
//  Copyright © 2025 kr.co.HaruDam. All rights reserved.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject private var authStore: AuthStore
    
    var body: some View {
        if !authStore.isBootstrapped {
            // 앱 시작 후 세션 확인
            SplashView()
        } else if authStore.isLoggedIn {
            // 로그인 상태
            MainTabView()
        } else {
            // 로그아웃 상태
            SignUpView()
        }
    }
}
