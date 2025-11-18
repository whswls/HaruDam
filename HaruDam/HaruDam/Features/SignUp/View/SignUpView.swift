//
//  SignUpView.swift
//  HaruDam
//
//  Created by 존진 on 11/12/25.
//

import SwiftUI
import AuthenticationServices

struct SignUpView: View {

    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @StateObject private var viewModel = SignUpViewModel()
    
    var body: some View {
        ZStack {
            // 배경
            AppColor.background.ignoresSafeArea()

            VStack {
                // 상단 여백
                Spacer().frame(height: 210)

                // 로고 + 리플 애니메이션
                RippleCircle(
                    size: 40,
                    gradient: RadialGradient(colors: [
                        AppColor.primary.opacity(0.70),
                        AppColor.primary.opacity(0.45),
                        AppColor.primary.opacity(0.25)
                    ], center: .center, startRadius: 0, endRadius: 100),
                    blur: 2,
                    shadow1: (AppColor.primary.opacity(0.5), 40),
                    shadow2: (AppColor.primary.opacity(0.3), 80),
                    scaleFrom: 1.0, scaleTo: 1.35, opacityFrom: 0.6, opacityTo: 0.0,
                    duration: 3.0, delay: 0.3,
                    repeatCount: Int.max
                )
                .padding(.bottom, 24)

                Spacer().frame(height: 40)
                // 헤드라인
                VStack(spacing: 8) {
                    Text("하루의 감정을,\n가볍게 기록하세요")
                        .multilineTextAlignment(.center)
                        .font(.title2.weight(.semibold))
                        .foregroundStyle(AppColor.textPrimary)

                    Text("소셜 계정으로 10초 만에 시작하기")
                        .font(.subheadline)
                        .foregroundStyle(AppColor.textSecondary)
                }
                .padding(.horizontal, 24)

                Spacer().frame(height: 150)

                // 소셜 로그인 버튼
                VStack(spacing: 12) {
                    // Apple
                    HStack(spacing: 15) {
                        Image(systemName: "applelogo")
                            .font(.system(size: 20))
                            .foregroundStyle(AppColor.appleText)
                        Text("Apple로 로그인")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundStyle(AppColor.appleText)
                            
                    }
                    .frame(maxWidth: .infinity, minHeight: 50)
                        .padding(.horizontal, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(AppColor.appleFill)
                        )
                    
                    
                    // Google
                    Button {
                        
                    } label: {
                        HStack(spacing: 14) {
                            Spacer()
                            if colorScheme == .dark {
                                Image("google_logo_circle_dark")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .clipShape(Circle().inset(by: 2))
                                    .background(
                                        Circle().fill(AppColor.googleFill)
                                    )
                            } else {
                                Image("google_logo_circle")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .clipShape(Circle().inset(by: 2))
                                    .background(
                                        Circle().fill(AppColor.googleFill)
                                    )
                            }
                            Text("Google로 로그인")
                                .font(.custom("Roboto-Medium", size: 18))
                                .foregroundColor(AppColor.googleText)
                                .padding(.leading, -10)

                            Spacer()
                        }
                        .frame(maxWidth: .infinity, minHeight: 48)
                        .padding(.horizontal, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(AppColor.googleFill)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(AppColor.googleStroke, lineWidth: 1)
                        )
                    }
                    
                    // Kakao
                    Button {
                        viewModel.kakaoLoginButtonTapped()
                    } label: {
                        HStack(spacing: 15) {
                            Image("kakao_logo")
                                .resizable()
                                .frame(width: 20, height: 20)

                            Text("Kakao로 로그인")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(AppColor.kakaoLabel.opacity(0.85))
                        }
                        .frame(maxWidth: .infinity, minHeight: 44)
                        .padding(.horizontal, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(AppColor.kakaoFill)
                        )
                    }
                }
                .padding(.horizontal, 24)
                .buttonStyle(.plain) 
                Spacer()
            }
        }
    }
}

#Preview {
    SignUpView()
}
