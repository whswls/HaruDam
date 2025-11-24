//
//  HaruDamApp.swift
//  HaruDam
//
//  Created by 존진 on 11/5/25.
//

import SwiftUI
import CoreData

@main
struct HaruDamApp: App {
    @StateObject private var appViewModel = AppViewModel()
    // CoreData
    let persistentController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            Group {
                if appViewModel.isLoggedIn {
                    HomeView()
                } else {
                    SplashView()
                }
            }
            .environmentObject(appViewModel)
            .environment(\.managedObjectContext,
                          persistentController.container.viewContext)
        }
        
    }
}
