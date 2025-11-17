//
//  UserProfileCoreDataTests.swift
//  HaruDamTests
//
//  Created by 존진 on 11/17/25.
//

import XCTest
import CoreData
@testable import HaruDam

final class UserProfileCoreDataTests: XCTestCase {

    var persistenceController: PersistenceController!
        var context: NSManagedObjectContext!

        override func setUpWithError() throws {
            try super.setUpWithError()

            // 메모리 전용 Core Data 스택 사용 (디스크에 안 남음)
            persistenceController = PersistenceController(inMemory: true)
            context = persistenceController.container.viewContext
        }

        override func tearDownWithError() throws {
            persistenceController = nil
            context = nil
            try super.tearDownWithError()
        }

        func testInsertAndFetchUserProfile() throws {
            // 더미 데이터
            let user = UserProfile(context: context)
            user.email = "test@harudam.com"
            user.nickname = "테스트유저"
            user.createdAt = Date()

            try context.save()

            // UserProfile 조회
            let request: NSFetchRequest<UserProfile> = UserProfile.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]

            let results = try context.fetch(request)

            // 검증
            XCTAssertEqual(results.count, 1)
            XCTAssertEqual(results.first?.email, "test@harudam.com")
            XCTAssertEqual(results.first?.nickname, "테스트유저")
        }

}
