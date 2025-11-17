//
//  PersistenceController.swift
//  HaruDam
//
//  Created by 존진 on 11/17/25.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    
    // preview, test용
    static var preview: PersistenceController = {
        let controller = PersistenceController(inMemory: true)
        let context = controller.container.viewContext
        
        // 더미 데이터
        let sample = UserProfile(context: context)
        sample.email = "preview@example.com"
        sample.nickname = "프리뷰유저"
        sample.createdAt = Date()
        
        do {
            try context.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        
        return controller
    }()
    
    let container: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "HaruDamModel")
        
        if inMemory {
            // 테스트용: 메모리에 저장
            if let description = container.persistentStoreDescriptions.first {
                description.url = URL(fileURLWithPath: "/dev/null")
            }
        }
        
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
    
}
