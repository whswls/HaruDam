//
//  User.swift
//  HaruDam
//
//  Created by 존진 on 11/19/25.
//

import Foundation

struct User: Codable {
    let id: String
    let nickname: String?
    let createdAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case nickname
        case createdAt = "created_at"
    }
}
