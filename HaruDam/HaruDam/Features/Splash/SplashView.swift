//
//  SplashView.swift
//  HaruDam
//
//  Created by 존진 on 11/6/25.
//

import SwiftUI

struct SplashView: View {
    // 애니메이션 트리거
    @State private var play = false
    @State private var showTitle = false
    @State private var showSubtitle = false

    var body: some View {
        ZStack {
            // 배경색
            AppColor.background.ignoresSafeArea()

            // 리플 애니메이션 컨테이너 (400x400)
            ZStack {
                // 1) 첫 번째 리플
                RippleCircle(
                    size: 220,
                    gradient: RadialGradient(colors: [
                        AppColor.primary.opacity(0.70),
                        AppColor.primary.opacity(0.45),
                        AppColor.primary.opacity(0.25)
                    ], center: .center, startRadius: 0, endRadius: 100),
                    blur: 2,
                    shadow1: (AppColor.primary.opacity(0.5), 40),
                    shadow2: (AppColor.primary.opacity(0.3), 80),
                    scaleFrom: 0.6, scaleTo: 1.4, opacityFrom: 1, opacityTo: 0,
                    duration: 3, delay: 0, repeatCount: 1
                )
                // 2) 두 번째 리플
                RippleCircle(
                    size: 230,
                    gradient: RadialGradient(colors: [
                        AppColor.primary.opacity(0.60),
                        AppColor.primary.opacity(0.40),
                        AppColor.primary.opacity(0.20)
                    ], center: .center, startRadius: 0, endRadius: 100),
                    blur: 2,
                    shadow1: (AppColor.primary.opacity(0.4), 40),
                    shadow2: (AppColor.primary.opacity(0.3), 80),
                    scaleFrom: 0.6, scaleTo: 1.4, opacityFrom: 0.8, opacityTo: 0,
                    duration: 2, delay: 0.3, repeatCount: 1
                )
                // 3) 세 번째 리플
                RippleCircle(
                    size: 240,
                    gradient: RadialGradient(colors: [
                        AppColor.primary.opacity(0.50),
                        AppColor.primary.opacity(0.30),
                        AppColor.primary.opacity(0.15)
                    ], center: .center, startRadius: 0, endRadius: 100),
                    blur: 2,
                    shadow1: (AppColor.primary.opacity(0.4), 40),
                    shadow2: (AppColor.primary.opacity(0.3), 80),
                    scaleFrom: 0.6, scaleTo: 1.4, opacityFrom: 0.6, opacityTo: 0,
                    duration: 2, delay: 0.6, repeatCount: 1
                )

                // 중앙 글로우
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                AppColor.primary.opacity(0.95),
                                AppColor.primary.opacity(0.65),
                                AppColor.primary.opacity(0.35),
                                .clear
                            ],
                            center: .center,
                            startRadius: 0,
                            endRadius: 60
                        )
                    )
                    .frame(width: 60, height: 60)
                    .blur(radius: 3)
                    .shadow(color: AppColor.primary.opacity(0.7), radius: 30)

                // 중앙 코어
                Circle()
                    .fill(
                        RadialGradient(colors: [AppColor.primary, AppColor.primary.opacity(0.8)],
                                       center: .center, startRadius: 0, endRadius: 20)
                    )
                    .frame(width: 20, height: 20)
                    .shadow(color: AppColor.primary.opacity(0.9), radius: 20)
            }
            .frame(width: 400, height: 400)
            .offset(y: -30)

            VStack(spacing: 10) {
                Text("하루담")
                    .font(.system(size: 37))
                    .fontWeight(.semibold)
                    .kerning(0.09 * 16) // 텍스트 자간 설정
                    .foregroundColor(AppColor.textPrimary)
                    .shadow(color: AppColor.textPrimary.opacity(0.2), radius: 12, x: 0, y: 2)
                    .opacity(showTitle ? 1 : 0)
                    .offset(y: showTitle ? 0 : 8)
                    .animation(.timingCurve(0.42, 0, 0.58, 1, duration: 0.8)
                                .delay(1), value: showTitle)

                Text("작은 감정도, 하루담에.")
                    .font(.system(size: 14))
                    .fontWeight(.light)
                    .kerning(0.17 * 16)
                    .foregroundColor(AppColor.textSecondary)
                    .opacity(showSubtitle ? 1 : 0)
                    .animation(.timingCurve(0.42, 0, 0.58, 1, duration: 0.8)
                                .delay(1.3), value: showSubtitle)
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
            .padding(.bottom, UIScreen.main.bounds.height * 0.23)
        }
        .onAppear {
            // 텍스트 타이밍
            showTitle = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                showSubtitle = true
            }
            // 리플 트리거
            play = true
        }
    }
}

#Preview {
    SplashView()
}
