//
//  NotificationCardView.swift
//  HaruDam
//
//  Created by 존진 on 12/8/25.
//  Copyright © 2025 kr.co.HaruDam. All rights reserved.
//

import SwiftUI

struct NotificationCardView: View {
    @Binding var isOn: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color.blue.opacity(0.10))
                    .frame(width: 36, height: 36)
                
                Image(systemName: "bell")
                    .font(.system(size: 16))
                    .foregroundColor(Color.blue)
            }
            
            Text("알림 받기")
                .font(.system(size: 16))
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .labelsHidden()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
        )
    }
}

#Preview {
    NotificationCardView(isOn: .constant(true))
}
