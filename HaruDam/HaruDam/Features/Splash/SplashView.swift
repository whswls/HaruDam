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
            Color(hex: "#FFFDF9").ignoresSafeArea()

            // 리플 애니메이션 컨테이너 (400x400)
            ZStack {
                // 1) 첫 번째 리플
                RippleCircle(
                    size: 220,
                    gradient: RadialGradient(colors: [
                        Color(hex: "#A7D8F0").opacity(0.70),
                        Color(hex: "#B8E8E0").opacity(0.45),
                        Color(hex: "#EAD3FF").opacity(0.25)
                    ], center: .center, startRadius: 0, endRadius: 100),
                    blur: 2,
                    shadow1: (Color(hex: "#A7D8F0").opacity(0.5), 40),
                    shadow2: (Color(hex: "#A7D8F0").opacity(0.3), 80),
                    scaleFrom: 0.6, scaleTo: 1.4, opacityFrom: 1, opacityTo: 0,
                    duration: 3, delay: 0, repeatCount: 1
                )
                // 2) 두 번째 리플
                RippleCircle(
                    size: 230,
                    gradient: RadialGradient(colors: [
                        Color(hex: "#B8E8E0").opacity(0.60),
                        Color(hex: "#A7D8F0").opacity(0.40),
                        Color(hex: "#EAD3FF").opacity(0.20)
                    ], center: .center, startRadius: 0, endRadius: 100),
                    blur: 2,
                    shadow1: (Color(hex: "#B8E8E0").opacity(0.4), 40),
                    shadow2: (Color(hex: "#A7D8F0").opacity(0.3), 80),
                    scaleFrom: 0.6, scaleTo: 1.4, opacityFrom: 0.8, opacityTo: 0,
                    duration: 2, delay: 0.3, repeatCount: 1
                )
                // 3) 세 번째 리플
                RippleCircle(
                    size: 240,
                    gradient: RadialGradient(colors: [
                        Color(hex: "#EAD3FF").opacity(0.50),
                        Color(hex: "#A7D8F0").opacity(0.30),
                        Color(hex: "#B8E8E0").opacity(0.15)
                    ], center: .center, startRadius: 0, endRadius: 100),
                    blur: 2,
                    shadow1: (Color(hex: "#EAD3FF").opacity(0.4), 40),
                    shadow2: (Color(hex: "#A7D8F0").opacity(0.3), 80),
                    scaleFrom: 0.6, scaleTo: 1.4, opacityFrom: 0.6, opacityTo: 0,
                    duration: 2, delay: 0.6, repeatCount: 1
                )

                // 중앙 글로우
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                Color(hex: "#A7D8F0").opacity(0.95),
                                Color(hex: "#B8E8E0").opacity(0.65),
                                Color(hex: "#EAD3FF").opacity(0.35),
                                .clear
                            ],
                            center: .center,
                            startRadius: 0,
                            endRadius: 60
                        )
                    )
                    .frame(width: 60, height: 60)
                    .blur(radius: 3)
                    .shadow(color: Color(hex: "#A7D8F0").opacity(0.7), radius: 30)

                // 중앙 코어
                Circle()
                    .fill(
                        RadialGradient(colors: [Color(hex: "#A7D8F0"), Color(hex: "#B8E8E0")],
                                       center: .center, startRadius: 0, endRadius: 20)
                    )
                    .frame(width: 20, height: 20)
                    .shadow(color: Color(hex: "#A7D8F0").opacity(0.9), radius: 20)
            }
            .frame(width: 400, height: 400)
            .offset(y: -30)

            VStack(spacing: 10) {
                Text("하루담")
                    .font(.system(size: 37))
                    .fontWeight(.semibold)
                    .kerning(0.08 * 16) // 텍스트 자간 설정
                    .foregroundColor(Color(hex: "#7B93A5"))
                    .shadow(color: Color(hex: "#7B93A5").opacity(0.2), radius: 12, x: 0, y: 2)
                    .opacity(showTitle ? 1 : 0)
                    .offset(y: showTitle ? 0 : 8)
                    .animation(.timingCurve(0.42, 0, 0.58, 1, duration: 0.8)
                                .delay(1), value: showTitle)

                Text("작은 감정도, 하루담에.")
                    .font(.system(size: 14))
                    .fontWeight(.light)
                    .kerning(0.15 * 16)
                    .foregroundColor(Color(hex: "#A7BCC9"))
                    .opacity(showSubtitle ? 1 : 0)
                    .animation(.timingCurve(0.42, 0, 0.58, 1, duration: 0.8)
                                .delay(1.3), value: showSubtitle)
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
            .padding(.bottom, UIScreen.main.bounds.height * 0.25)
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
