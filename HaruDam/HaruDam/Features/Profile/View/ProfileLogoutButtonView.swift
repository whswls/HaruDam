//
//  LogoutButtonView.swift
//  HaruDam
//
//  Created by 존진 on 12/8/25.
//  Copyright © 2025 kr.co.HaruDam. All rights reserved.
//

import SwiftUI

struct ProfileLogoutButtonView: View {
    var body: some View {
        Button {
            // 로그아웃 로직 연결 예정
        } label: {
            HStack(spacing: 8) {
                Image(systemName: "arrow.right.square")
                    .font(.system(size: 16, weight: .semibold))
                
                Text("로그아웃")
                    .font(.system(size: 16, weight: .semibold))
            }
            .foregroundColor(Color.red.opacity(0.8))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(Color.red.opacity(0.4), lineWidth: 1)
                    .background(
                        RoundedRectangle(cornerRadius: 18)
                            .fill(Color.red.opacity(0.04))
                    )
            )
        }
    }
}
