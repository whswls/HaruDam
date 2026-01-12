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
    
    var userName: String? {
        guard let value = session?.user.userMetadata["name"] as? AnyJSON else { return nil }
        
        if case let .string(name) = value {
            return name
        }
        
        return nil
    }
    
    var email: String? {
        session?.user.email
    }
    
    var displayUserName: String {
        userName ?? "사용자"
    }
    
    var displayEmail: String {
        email ?? ""
    }
    
    init(client: SupabaseClient = SupabaseManager.shared.client) {
        self.client = client
        
        authTask = Task {
            await bootstrapSession()
            await listenAuthChanges()
        }
    }
    
    deinit {
        authTask?.cancel()
    }
    
    var isLoggedIn: Bool { session != nil }
    var userId: String? { session?.user.id.uuidString }
    
    // 저장된 로그인 정보 확인
    private func bootstrapSession() async {
        do {
            let session = try await client.auth.session
            self.session = session
        } catch {
            self.session = nil
        }

        self.isBootstrapped = true
    }
    
    // 로그인 상태 변화 감시
    private func listenAuthChanges() async {
        await client.auth.onAuthStateChange { [weak self] _, session in
            Task { @MainActor in
                self?.session = session
            }
        }
    }
}
