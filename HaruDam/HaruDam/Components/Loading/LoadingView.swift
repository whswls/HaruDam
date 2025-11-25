//
//  LoadingView.swift
//  HaruDam
//
//  Created by 존진 on 11/24/25.
//

import SwiftUI

struct LoadingView: View {
    enum Variant {
        case fullscreen
        case inline
    }
    
    enum Size {
        case small
        case medium
        case large
        
        var symbol: CGFloat {
            switch self {
            case .small: return 48
            case .medium: return 80
            case .large: return 120
            }
        }
        
        var text: CGFloat {
            switch self {
            case .small: return 14
            case .medium: return 16
            case .large: return 20
            }
        }
        
        var gap: CGFloat {
            switch self {
            case .small: return 12
            case .medium: return 16
            case .large: return 24
            }
        }
        
        var dot: CGFloat {
            text * 0.3
        }
    }
    
    let variant: Variant
    let size: Size
    let message: String
    
    @State private var dotPhase: Int = 0
    
    init(
        variant: Variant = .fullscreen,
        size: Size = .medium,
        message: String = "감정을 불러오는 중..."
    ) {
        self.variant = variant
        self.size = size
        self.message = message
    }
    
    var body: some View {
        let content = VStack(spacing: size.gap) {
            RippleSymbolView(size: size)
            
            Text(message)
                .font(.system(size: size.text, weight: .regular))
                .foregroundColor(AppColor.textSecondary)
                .multilineTextAlignment(.center)
            
            HStack(spacing: 6) {
                ForEach(0..<3) { index in
                    Circle()
                        .fill(AppColor.primary)
                        .frame(width: size.dot, height: size.dot)
                        .offset(y: dotPhase == index ? -6 : 0)
                        .animation(
                            .easeInOut(duration: 0.5)
                            .repeatForever()
                            .delay(0.2 * Double(index)),
                            value: dotPhase
                        )
                }
            }
        }
            .onAppear {
                startDotLoop()
            }
        
        switch variant {
        case .inline:
            HStack {
                Spacer()
                content
                Spacer()
            }
            .padding(.vertical, 16)
        case .fullscreen:
            ZStack {
                AppColor.background.ignoresSafeArea()
                content
            }
        }
    }
    
    private func startDotLoop() {
        // 간단한 루프 애니메이션: 0 -> 1 -> 2 -> 0 ...
        Timer.scheduledTimer(withTimeInterval: 0.6, repeats: true) { _ in
            dotPhase = (dotPhase + 1) % 3
        }
    }
}

private struct RippleSymbolView: View {
    let size: LoadingView.Size
    
    var body: some View {
        ZStack {
            // 리플 1, 2, 3
            RippleCircle(
                size: size.symbol * 0.9,
                gradient: RadialGradient(
                    colors: [
                        AppColor.primary.opacity(0.3),
                        AppColor.secondary.opacity(0.15),
                        Color.clear
                    ],
                    center: .center,
                    startRadius: 0,
                    endRadius: size.symbol * 0.9
                ),
                blur: 1,
                shadow1: (Color.clear, 0),
                shadow2: (Color.clear, 0),
                scaleFrom: 1.0,
                scaleTo: 1.4,
                opacityFrom: 0.5,
                opacityTo: 0.0,
                duration: 2.5,
                delay: 0.0,
                repeatCount: 999
            )
            
            RippleCircle(
                size: size.symbol * 0.9,
                gradient: RadialGradient(
                    colors: [
                        AppColor.primary.opacity(0.25),
                        AppColor.secondary.opacity(0.12),
                        Color.clear
                    ],
                    center: .center,
                    startRadius: 0,
                    endRadius: size.symbol * 0.9
                ),
                blur: 1,
                shadow1: (Color.clear, 0),
                shadow2: (Color.clear, 0),
                scaleFrom: 1.0,
                scaleTo: 1.4,
                opacityFrom: 0.4,
                opacityTo: 0.0,
                duration: 2.5,
                delay: 0.4,
                repeatCount: 999
            )
            
            RippleCircle(
                size: size.symbol * 0.9,
                gradient: RadialGradient(
                    colors: [
                        AppColor.primary.opacity(0.2),
                        AppColor.secondary.opacity(0.1),
                        Color.clear
                    ],
                    center: .center,
                    startRadius: 0,
                    endRadius: size.symbol * 0.9
                ),
                blur: 1,
                shadow1: (Color.clear, 0),
                shadow2: (Color.clear, 0),
                scaleFrom: 1.0,
                scaleTo: 1.4,
                opacityFrom: 0.3,
                opacityTo: 0.0,
                duration: 2.5,
                delay: 0.8,
                repeatCount: 999
            )
            
            // 중앙 글로우
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            AppColor.primary.opacity(0.4),
                            AppColor.secondary.opacity(0.2),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: 0,
                        endRadius: size.symbol * 0.4
                    )
                )
                .frame(width: size.symbol * 0.4)
                .blur(radius: 2)
            
            // 중앙 코어
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            AppColor.primary,
                            AppColor.secondary
                        ],
                        center: .center,
                        startRadius: 0,
                        endRadius: size.symbol * 0.2
                    )
                )
                .frame(width: size.symbol * 0.25)
                .shadow(color: AppColor.secondary.opacity(0.5), radius: 8)
        }
        .frame(width: size.symbol, height: size.symbol)
    }
}

#Preview {
    VStack(spacing: 40) {
        LoadingView(variant: .inline, size: .small, message: "작은 로딩...")
        LoadingView(variant: .fullscreen, size: .medium)
            .frame(height: 300)
    }
}
