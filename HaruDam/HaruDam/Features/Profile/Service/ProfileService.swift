//
//  ProfileService.swift
//  HaruDam
//
//  Created by 존진 on 12/10/25.
//  Copyright © 2025 kr.co.HaruDam. All rights reserved.
//

import Foundation
import Supabase

protocol ProfileServiceProtocol {
    func fetchUserProfile(userId: String) async throws -> UserProfileModel
    func fetchProfileSummary(userId: UUID) async throws -> ProfileSummaryDTO
}

final class ProfileService: ProfileServiceProtocol {
    private let client: SupabaseClient

    init(client: SupabaseClient = SupabaseManager.shared.client) {
        self.client = client
    }

    func fetchUserProfile(userId: String) async throws -> UserProfileModel {
        let dto: UserProfileResponseDTO = try await client
            .from("profiles")
            .select()
            .eq("id", value: userId)
            .single()
            .execute()
            .value

        return dto.toModel()
    }
    
    // 프로필 카드 정보 조회
    func fetchProfileSummary(userId: UUID) async throws -> ProfileSummaryDTO {
            let result: [ProfileSummaryDTO] = try await client
                .rpc("get_profile_summary", params: ["p_user_id": userId.uuidString])
                .execute()
                .value

            // 결과가 없는 경우
            return result.first ?? ProfileSummaryDTO(totalRecords: 0, streakDays: 0, mostFrequentEmotion: "-")
        }
}
