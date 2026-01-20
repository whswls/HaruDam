//
//  EmotionRecordEditViewModel.swift
//  HaruDam
//
//  Created by 존진 on 1/20/26.
//  Copyright © 2026 kr.co.HaruDam. All rights reserved.
//

import Foundation
import CoreData

// MARK: - SyncStatus
enum SyncStatus: String {
    case pending
    case synced
    case failed
}

@MainActor
final class EmotionRecordEditViewModel: ObservableObject {
    @Published var emotion: String
    @Published var title: String
    @Published var content: String
    @Published var tags: [String]
    
    // UI 상태
    @Published var isSyncing: Bool = false
    @Published var errorMessage: String? = nil
    
    private let record: EmotionRecordEntity
    
    init(record: EmotionRecordEntity) {
        self.record = record
        self.emotion = record.emotion ?? "🙂"
        self.title = record.title ?? ""
        self.content = record.content ?? ""
        self.tags = Self.decodeTagsJson(record.tags)
    }
    
    var canSave: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    // MARK: - Update
    func save(context: NSManagedObjectContext) async {
        guard canSave else { return }
        isSyncing = true
        errorMessage = nil
        
        record.emotion = emotion
        record.title = title
        record.content = content
        record.updatedAt = Date()
        record.syncStatus = SyncStatus.pending.rawValue
        record.tags = Self.encodeTagsJson(tags)
        
        do {
            try context.save()
        } catch {
            context.rollback()
            errorMessage = "로컬 수정에 실패했어요."
            isSyncing = false
            return
        }
        
        // 서버 update (serverId 없으면 서버에 아직 없음 → pending 유지)
        guard record.serverId != nil else {
            isSyncing = false
            return
        }
        
        do {
            try await EmotionRecordService.shared.update(record: record)
            record.syncStatus = SyncStatus.synced.rawValue
            record.updatedAt = Date()
            try context.save()
        } catch {
            record.syncStatus = SyncStatus.failed.rawValue
            try? context.save()
            errorMessage = "서버 동기화(수정)에 실패했어요."
        }
        
        isSyncing = false
    }
    
    // MARK: - Delete
    func delete(context: NSManagedObjectContext) async {
        isSyncing = true
        errorMessage = nil
        
        // delete 전에 serverId 캡처
        let serverId = record.serverId
        
        // 로컬 삭제
        context.delete(record)
        do {
            try context.save()
        } catch {
            context.rollback()
            errorMessage = "로컬 삭제에 실패했어요."
            isSyncing = false
            return
        }
        
        // 서버 삭제 (serverId 없으면 종료)
        guard let serverId, !serverId.isEmpty else {
            isSyncing = false
            return
        }
        
        do {
            try await EmotionRecordService.shared.delete(recordId: serverId)
        } catch {
            errorMessage = "서버 동기화(삭제)에 실패했어요."
        }
        
        isSyncing = false
    }
    
    // MARK: - Tags(JSON)
    private static func encodeTagsJson(_ tags: [String]) -> String {
        do {
            let data = try JSONEncoder().encode(tags)
            return String(data: data, encoding: .utf8) ?? "[]"
        } catch {
            return "[]"
        }
    }
    
    private static func decodeTagsJson(_ json: String?) -> [String] {
        guard let json, let data = json.data(using: .utf8) else { return [] }
        return (try? JSONDecoder().decode([String].self, from: data)) ?? []
    }
}
