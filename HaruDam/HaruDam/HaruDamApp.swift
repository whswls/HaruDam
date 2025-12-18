//
//  HaruDamApp.swift
//  HaruDam
//
//  Created by 존진 on 11/5/25.
//

import SwiftUI
import CoreData
import GoogleSignIn

@main
struct HaruDamApp: App {
    @StateObject private var appViewModel = AppViewModel()
    @EnvironmentObject private var authStore: AuthStore
    // CoreData
    let persistentController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            Group {
                if !authStore.isBootstrapped {
                    // 앱 시작 직후 세션 확인
                    SplashView()
                } else if authStore.isLoggedIn {
                    // 로그인 상태
                    MainTabView()
                } else {
                    // 로그아웃 상태
                    SignUpView()
                }
            }
            .environmentObject(appViewModel)
            .environment(\.managedObjectContext,
                          persistentController.container.viewContext)
            .onOpenURL { url in
                GIDSignIn.sharedInstance.handle(url)
            }
        }
        
    }
}
