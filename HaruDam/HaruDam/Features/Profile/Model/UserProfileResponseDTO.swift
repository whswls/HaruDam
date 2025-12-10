//
//  UserProfileResponseDTO.swift
//  HaruDam
//
//  Created by 존진 on 12/10/25.
//  Copyright © 2025 kr.co.HaruDam. All rights reserved.
//

import Foundation

struct UserProfileResponseDTO: Codable {
    let id: String
    let email: String
    let nickname: String
    let profileImageURL: String?
    let createdAt: String?
}
