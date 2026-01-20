//
//  EmotionRecordService.swift
//  HaruDam
//
//  Created by 존진 on 1/20/26.
//  Copyright © 2026 kr.co.HaruDam. All rights reserved.
//

import Foundation
import Supabase
import CoreData

final class EmotionRecordService {
    static let shared = EmotionRecordService()
    private let supabase: SupabaseManager

    init(supabase: SupabaseManager = .shared) {
        self.supabase = supabase
    }

    private struct InsertResponse: Decodable {
        let id: String
    }

    // MARK: - DTO
    private struct EmotionRecordInsertDTO: Encodable {
        let user_id: String
        let emotion: String
        let title: String
        let content: String
        let tags: [String]
        let created_at: String
        let updated_at: String
    }

    private struct EmotionRecordUpdateDTO: Encodable {
        let emotion: String
        let title: String
        let content: String
        let tags: [String]
        let updated_at: String
    }

    private func decodeTagsJson(_ json: String?) -> [String] {
        guard let json, let data = json.data(using: .utf8) else { return [] }
        return (try? JSONDecoder().decode([String].self, from: data)) ?? []
    }

    private let isoFormatter: ISO8601DateFormatter = {
        let f = ISO8601DateFormatter()
        f.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return f
    }()

    /// Supabase - insert 생성된 서버 id(uuid)를 반환
    /// - Note: 테이블명은 `emotion_records`사용
    func insert(record: EmotionRecordEntity) async throws -> String {
        // Supabase Auth 세션에서 user_id 가져오기
        let session = try await supabase.client.auth.session
        let userId = session.user.id.uuidString

        let tagsArray = decodeTagsJson(record.tags)

        let payload = EmotionRecordInsertDTO(
            user_id: userId,
            emotion: record.emotion ?? "",
            title: record.title ?? "",
            content: record.content ?? "",
            tags: tagsArray,
            created_at: isoFormatter.string(from: record.createdAt ?? Date()),
            updated_at: isoFormatter.string(from: record.updatedAt ?? Date())
        )

        let inserted: [InsertResponse] = try await supabase.client
            .from("emotion_records")
            .insert(payload)
            .select("id")
            .execute()
            .value

        guard let serverId = inserted.first?.id else {
            throw NSError(domain: "EmotionRecordService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Insert 응답에서 id를 받지 못했습니다."])
        }

        return serverId
    }

    /// Supabase - update  (record.serverId 필요)
    func update(record: EmotionRecordEntity) async throws {
        guard let serverId = record.serverId, !serverId.isEmpty else { return }

        let tagsArray = decodeTagsJson(record.tags)

        let payload = EmotionRecordUpdateDTO(
            emotion: record.emotion ?? "",
            title: record.title ?? "",
            content: record.content ?? "",
            tags: tagsArray,
            updated_at: isoFormatter.string(from: record.updatedAt ?? Date())
        )

        _ = try await supabase.client
            .from("emotion_records")
            .update(payload)
            .eq("id", value: serverId)
            .execute()
    }

    /// Supabase - delete
    func delete(recordId: String) async throws {
        guard !recordId.isEmpty else { return }

        _ = try await supabase.client
            .from("emotion_records")
            .delete()
            .eq("id", value: recordId)
            .execute()
    }

    func delete(record: EmotionRecordEntity) async throws {
        guard let serverId = record.serverId, !serverId.isEmpty else { return }
        try await delete(recordId: serverId)
    }
}
