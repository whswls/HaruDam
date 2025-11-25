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
    private var authService: AuthService = .shared
    
    func kakaoLoginButtonTapped() {
        guard !isLoading else { return }
        Task {
            await kakaoLogin()
        }
    }
    
    func googleLoginButtonTapped() {
        guard !isLoading else { return }
        Task {
            await googleLogin()
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
    
    private func googleLogin() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        
        do {
            _ = try await authService.signInWithGoogleAndEnsureUser()
            
            onLoginSuccess?()
        } catch {
            errorMessage = "구글 로그인에 실패했어요. 잠시 후 다시 시도해주세요."
        }
    }
    
}
