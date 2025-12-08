//
//  SettingRowToggleView.swift
//  HaruDam
//
//  Created by 존진 on 12/8/25.
//  Copyright © 2025 kr.co.HaruDam. All rights reserved.
//

import SwiftUI

struct SettingRowToggleView: View {
    let iconSystemName: String
    let iconBackground: Color
    let title: String
    @Binding var isOn: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(iconBackground)
                    .frame(width: 36, height: 36)
                
                Image(systemName: iconSystemName)
                    .font(.system(size: 16))
                    .foregroundColor(.primary)
            }
            
            Text(title)
                .font(.system(size: 16))
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .labelsHidden()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
    }
}
