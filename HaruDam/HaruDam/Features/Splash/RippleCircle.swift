//
//  RippleCircle.swift
//  HaruDam
//
//  Created by 존진 on 11/6/25.
//

import SwiftUI

/// 애니메이션  원형 리플
struct RippleCircle: View {
    let size: CGFloat
    let gradient: RadialGradient
    let blur: CGFloat
    let shadow1: (Color, CGFloat)
    let shadow2: (Color, CGFloat)
    let scaleFrom: CGFloat
    let scaleTo: CGFloat
    let opacityFrom: CGFloat
    let opacityTo: CGFloat
    let duration: Double
    let delay: Double
    let repeatCount: Int  // Framer의 repeat: 1 => 총 2회 재생

    @State private var scale: CGFloat = 1
    @State private var alpha: CGFloat = 1

    var body: some View {
        Circle()
            .fill(gradient)
            .frame(width: size, height: size)
            .blur(radius: blur)
            .shadow(color: shadow1.0, radius: shadow1.1)
            .shadow(color: shadow2.0, radius: shadow2.1)
            .scaleEffect(scale)
            .opacity(alpha)
            .onAppear {
                scale = scaleFrom
                alpha = opacityFrom

                // 커브: cubic-bezier(0.42, 0, 0.58, 1)
                let base = Animation.timingCurve(0.42, 0, 0.58, 1, duration: duration)
                    .delay(delay)

                // repeatCount 횟수만큼 왕복 없이 같은 방향으로 반복되게 구현
                func playOnce(_ i: Int) {
                    withAnimation(base) {
                        scale = scaleTo
                        alpha = opacityTo
                    }
                    // 다음 반복 준비(초기값으로 리셋)
                    DispatchQueue.main.asyncAfter(deadline: .now() + delay + duration + 0.3) {
                        if i < repeatCount {
                            scale = scaleFrom
                            alpha = opacityFrom
                            playOnce(i + 1)
                        }
                    }
                }
                playOnce(0)
            }
    }
}
