//
//  AuthService.swift
//  HaruDam
//
//  Created by 존진 on 11/19/25.
//

import Foundation
import Auth
import Supabase

final class AuthService {
    static let shared = AuthService()
    private let supabase: SupabaseManager
    
    init(supabase: SupabaseManager = .shared) {
        self.supabase = supabase
    }
    
    // MARK: - Kakao
    func signInWithKakao() async throws -> Session {
        try await supabase.client.auth.signInWithOAuth(provider: .kakao,
                                                       redirectTo: URL(string: SupabaseManager.Auth.appRedirect))
    }
    
    /// 카카오 로그인 + user 테이블 자동 가입
    func signInWithKakaoAndEnsureUser() async throws -> Session {
        // Supabase Auth 카카오 로그인
        let session = try await signInWithKakao()
        
        let authUser = session.user
        
        // DB에 유저 row 없으면 생성
        try await ensureUserExists(for: authUser)
        
        return session
    }
    
    // MARK: - Apple
    func signInWithApple() async throws -> Session {
        try await supabase.client.auth.signInWithOAuth(provider: .apple,
                                                       redirectTo: URL(string: SupabaseManager.Auth.appRedirect)
        )
    }
    
    /// 애플 로그인 + user 테이블 자동 가입
    func signInWithAppleAndEnsureUser() async throws -> Session {
        let session = try await signInWithApple()
        
        let authUser = session.user
        
        try await ensureUserExists(for: authUser)
        
        return session
    }
    
    // MARK: - Google
    func signInWithGoogle() async throws -> Session {
        try await supabase.client.auth.signInWithOAuth(provider: .google,
                                                       redirectTo: URL(string: SupabaseManager.Auth.appRedirect))
    }
    
    func signInWithGoogleAndEnsureUser() async throws -> Session {
        let session = try await signInWithGoogle()
        
        let authUser = session.user
        
        try await ensureUserExists(for: authUser)
        
        return session
    }
    
    // MARK: - Private
    
    /// Supabase DB의 user 테이블에 아직 row가 없으면 새로 생성
    private func ensureUserExists(for authUser: Auth.User) async throws {
        let userId = authUser.id.uuidString
        
        // 이미 있는지 조회
        let existing: [User] = try await supabase.client
            .from("user")
            .select()
            .eq("id", value: userId)
            .limit(1)
            .execute()
            .value
        
        if !existing.isEmpty {
            // 기존 회원이면 패스
            return
        }
        
        let rawName = authUser.userMetadata["name"]
            ?? authUser.userMetadata["user_name"]

        let nickname: String
        if let rawName {
            let nameString = String(describing: rawName).trimmingCharacters(in: .whitespacesAndNewlines)
            nickname = nameString.isEmpty ? "새로운 기록자" : nameString
        } else {
            nickname = "새로운 기록자"
        }
        
        let newUser = User(
            id: userId,
            nickname: nickname,
            createdAt: Date()
        )
        
        do {
            _ = try await supabase.client
                .from("user")
                .insert(newUser)
                .execute()
        } catch {
            print("[AuthService] insert user failed:", error)
            throw error
        }
    }
}

// MARK: - Error

enum AuthServiceError: Error {
    case missingUser
}
