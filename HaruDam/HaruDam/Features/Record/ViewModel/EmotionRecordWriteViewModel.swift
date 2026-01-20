//
//  EmotionRecordWriteViewModel.swift
//  HaruDam
//
//  Created by 존진 on 1/20/26.
//  Copyright © 2026 kr.co.HaruDam. All rights reserved.
//

import Foundation
import CoreData

@MainActor
final class EmotionRecordWriteViewModel: ObservableObject {
    @Published var emotion: String = "☺️"
    @Published var title: String = ""
    @Published var content: String = ""
    @Published var date: Date = Date()
    @Published var tags: [String] = []
    
    // UI 상태
    @Published var isSaving: Bool = false
    @Published var errorMessage: String? = nil
    
    var canSave: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    func save(context: NSManagedObjectContext) async {
        guard canSave else { return }
        isSaving = true
        errorMessage = nil
        
        let record = EmotionRecordEntity(context: context)
        record.id = UUID()
        record.emotion = emotion
        record.title = title
        record.content = content
        record.createdAt = date
        record.updatedAt = Date()
        record.serverId = nil
        record.syncStatus = SyncStatus.pending.rawValue
        
        record.tags = encodeTagsJson(tags)
        
        do {
            try context.save()
        } catch {
            context.rollback()
            errorMessage = "로컬 저장에 실패했습니다. (\(error.localizedDescription))"
            isSaving = false
            return
        }
        
        do {
            let serverId = try await EmotionRecordService.shared.insert(record: record)
            record.serverId = serverId
            record.syncStatus = SyncStatus.synced.rawValue
            record.updatedAt = Date()
            try context.save()
        } catch {
            record.syncStatus = SyncStatus.failed.rawValue
            try? context.save()
            errorMessage = "서버 동기화에 실패했습니다. (\(error.localizedDescription))"
        }
        
        isSaving = false
        
    }
    
    private func encodeTagsJson(_ tags: [String]) -> String {
        do {
            let data = try JSONEncoder().encode(tags)
            return String(data: data, encoding: .utf8) ?? "[]"
        } catch {
            return "[]"
        }
    }
}
