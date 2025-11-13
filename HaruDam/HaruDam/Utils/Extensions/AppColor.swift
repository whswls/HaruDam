//
//  AppColor.swift
//  HaruDam
//
//  Created by 존진 on 11/6/25.
//

import SwiftUI

// MARK: - AppColor
/// 앱 전반에서 사용할 의미 기반 색상
/// 모든 색상은 Assets.xcassets의 Named Color 참조
struct AppColor {
    // Brand
    static let primary       = Color("BrandPrimary")
    static let secondary     = Color("BrandSecondary")
    
    // Background
    static let background    = Color("BackgroundBase")
    static let surface       = Color("BackgroundSurface")
    
    // Text
    static let textPrimary   = Color("TextPrimary")
    static let textSecondary = Color("TextSecondary")
    
    // Accent
    static let accentSuccess = Color("AccentSuccess")
    static let accentWarning = Color("AccentWarning")
    static let accentError   = Color("AccentError")
    
    // Gray
    static let gray100       = Color("Gray100")
    static let gray200       = Color("Gray200")
    static let gray300       = Color("Gray300")
    
    // Google
    static let googleFill    = Color("GoogleFill")
    static let googleStroke  = Color("GoogleStroke")
    static let googleText    = Color("GoogleText")
    
    // Kakao
    static let kakaoFill    = Color("KakaoFill")
    static let kakaoLabel   = Color("KakaoLabel")
}
