//
//  KeychainManager.swift
//  HaruDam
//
//  Created by 존진 on 12/11/25.
//  Copyright © 2025 kr.co.HaruDam. All rights reserved.
//

import Foundation
import Security

enum KeychainKey: String{
    case userId
}

final class KeychainManager {
    static let shared = KeychainManager()
    private init() {}
    
    @discardableResult
    func save(_ value: String, for key: KeychainKey) -> Bool {
        guard let data = value.data(using: .utf8) else { return false }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key.rawValue
        ]
        
        // 기존 값 삭제
        SecItemDelete(query as CFDictionary)
        
        // 새 값 추가
        let attributes: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key.rawValue,
            kSecValueData as String: data
        ]
        
        let status = SecItemAdd(attributes as CFDictionary, nil)
        return status == errSecSuccess
    }
}
