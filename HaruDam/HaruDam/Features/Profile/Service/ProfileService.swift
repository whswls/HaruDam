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
}

struct ProfileService: ProfileServiceProtocol {
    let client: SupabaseClient

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
}
