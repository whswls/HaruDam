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

extension UserProfileResponseDTO {
    func toModel() -> UserProfileModel {
        let date: Date? = {
            guard let createdAt else { return nil }
            
            let formatter = ISO8601DateFormatter()
            return formatter.date(from: createdAt)
        }()
        
        let imageURL: URL? = {
            guard let profileImageURL else { return nil }
            return URL(string: profileImageURL)
        }()
        
        return UserProfileModel(id: id, email: email, nickname: nickname, profileImageURL: imageURL, createdAt: date)
    }
}
