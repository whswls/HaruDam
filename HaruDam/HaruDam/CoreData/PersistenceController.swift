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

        // 더미 데이터는 엔티티 이름 변경/삭제 시 컴파일 에러가 날 수 있어,
        // Preview 스토어는 기본 컨텍스트만 초기화합니다.

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
