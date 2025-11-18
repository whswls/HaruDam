//
//  SignUpViewModel.swift
//  HaruDam
//
//  Created by 존진 on 11/18/25.
//

import Foundation
import Combine
import Auth

@MainActor
class SignUpViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    // 로그인 성공 시 상위에서 화면 전환할 때 사용
    var onLoginSuccess: (() -> Void)?
    
    private let supabaseManager: SupabaseManager
    
    init(supabaseManager: SupabaseManager = .shared) {
            self.supabaseManager = supabaseManager
    }
    
    func kakaoLoginButtonTapped() {
        Task {
            await kakaoLogin()
        }
    }
    
    private func kakaoLogin() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        
        do {
            // Supabase를 통해 카카오 OAuth 로그인
            let response = try await supabaseManager.signInWithKakao()
            
            // TODO: 여기서 로그인된 유저 정보 저장/전달 (필요 시)
            onLoginSuccess?()
        } catch {
            errorMessage = "카카오 로그인에 실패했어요. 잠시 후 다시 시도해주세요."
        }
    }
    
}
