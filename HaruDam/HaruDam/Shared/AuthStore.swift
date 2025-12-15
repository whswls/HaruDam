//
//  AuthStore.swift
//  HaruDam
//
//  Created by 존진 on 12/15/25.
//  Copyright © 2025 kr.co.HaruDam. All rights reserved.
//

import Foundation
import Supabase

@MainActor
final class AuthStore: ObservableObject {
    @Published private(set) var session: Session? = nil
    @Published private(set) var isBootstrapped: Bool = false
    
    private let client: SupabaseClient
    private var authTask: Task<Void, Never>?
    
    init(client: SupabaseClient = SupabaseManager.shared.client) {
        self.client = client
    }
}
