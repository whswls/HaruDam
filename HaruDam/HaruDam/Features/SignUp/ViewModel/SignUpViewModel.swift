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
    private var authService: AuthService = AuthService()
    
    init(authService: AuthService){
        self.authService = authService
    }
    
    func kakaoLoginButtonTapped() {
        guard !isLoading else { return }
        Task {
            await kakaoLogin()
        }
    }
    
    private func kakaoLogin() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        
        do {
            _ = try await authService.signInWithKakaoAndEnsureUser()
            
            onLoginSuccess?()
        } catch {
            errorMessage = "카카오 로그인에 실패했어요. 잠시 후 다시 시도해주세요."
        }
    }
    
}
