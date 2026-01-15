//
//  EmotionRecordEntity+CoreDataProperties.swift
//  
//
//  Created by 존진 on 1/15/26.
//
//

public import Foundation
public import CoreData


public typealias EmotionRecordEntityCoreDataPropertiesSet = NSSet

extension EmotionRecordEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EmotionRecordEntity> {
        return NSFetchRequest<EmotionRecordEntity>(entityName: "EmotionRecordEntity")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var emotion: String?
    @NSManaged public var content: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var updatedAt: Date?
    @NSManaged public var serverId: String?
    @NSManaged public var tags: String?
    @NSManaged public var syncStatus: String?
    @NSManaged public var title: String?

}
