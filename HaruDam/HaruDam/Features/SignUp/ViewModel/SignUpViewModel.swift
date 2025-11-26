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
    
    func appleLoginButtonTapped() {
        guard !isLoading else { return }
        Task {
            await appleLogin()
        }
    }
    
    private func kakaoLogin() async {
        await performLogin(
            signInAction: { try await authService.signInWithKakaoAndEnsureUser() },
            failureMessage: "카카오 로그인에 실패했어요. 잠시 후 다시 시도해주세요.")
    }
    
    private func googleLogin() async {
        await performLogin(
            signInAction: { try await authService.signInWithGoogleAndEnsureUser() },
            failureMessage: "구글 로그인에 실패했어요. 잠시 후 다시 시도해주세요.")
    }
    
    private func appleLogin() async {
        await performLogin(
            signInAction: { try await authService.signInWithAppleAndEnsureUser() },
            failureMessage: "Apple 로그인에 실패했어요. 잠시 후 다시 시도해주세요."
        )
    }
    
    private func performLogin<T> (
        signInAction: () async throws -> T,
        failureMessage: String
    ) async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        
        do {
            _ = try await signInAction()
            onLoginSuccess?()
        } catch {
            errorMessage = failureMessage
        }
    }
    
}
