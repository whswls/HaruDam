//
//  ProfileService.swift
//  HaruDam
//
//  Created by 존진 on 12/10/25.
//  Copyright © 2025 kr.co.HaruDam. All rights reserved.
//

import Foundation

protocol ProfileServiceProtocol {
    func fetchUserProfile(userId: String) async throws -> UserProfileModel
}
