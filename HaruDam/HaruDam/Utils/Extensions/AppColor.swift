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
    static let primary       = Color("Brand/Primary")
    static let secondary     = Color("Brand/Secondary")
    
    // Background
    static let background    = Color("Background/Base")
    static let surface       = Color("Background/Surface")
    
    // Text
    static let textPrimary   = Color("Text/Primary")
    static let textSecondary = Color("Text/Secondary")
    
    // Accent
    static let accentSuccess = Color("Accent/Success")
    static let accentWarning = Color("Accent/Warning")
    static let accentError   = Color("Accent/Error")
    
    // Gray
    static let gray100       = Color("Gray/100")
    static let gray200       = Color("Gray/200")
    static let gray300       = Color("Gray/300")
}
