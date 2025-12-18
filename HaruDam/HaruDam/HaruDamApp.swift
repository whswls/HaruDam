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
    // CoreData
    let persistentController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(appViewModel)
                .environment(\.managedObjectContext,
                              persistentController.container.viewContext)
                .onOpenURL { url in
                    GIDSignIn.sharedInstance.handle(url)
                }
        }
        
    }
}
