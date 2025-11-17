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
    // CoreData
    let persistentController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            SplashView()
                .environment(\.managedObjectContext,
                              persistentController.container.viewContext)
        }
    }
}
