//
//  EmotionRecordWriteView.swift
//  HaruDam
//
//  Created by 존진 on 12/4/25.
//  Copyright © 2025 kr.co.HaruDam. All rights reserved.
//

import SwiftUI
import CoreData

struct EmotionRecordWriteView: View {
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) private var context
    
    @StateObject private var viewModel = EmotionRecordWriteViewModel()
    
    private let emojiOptions: [String] = ["😌", "😊", "😢", "😡", "😰", "🤔", "🥰", "🤯"]
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppColor.background.ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 24) {
                        
                        headerSection
                        emojiSection
                        titleSection
                        contentSection
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 24)
                    .padding(.bottom, 40)
                }
            }
            .navigationTitle("감정 기록 작성")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("취소") {
                        dismiss()
                    }
                    .foregroundColor(AppColor.textSecondary)
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("저장") {
                        Task {
                            await viewModel.save(context: context)
                            if viewModel.errorMessage == nil {
                                dismiss()
                            }
                        }
                    }
                    .foregroundColor(viewModel.canSave ? AppColor.primary : AppColor.textSecondary)
                    .disabled(!viewModel.canSave || viewModel.isSaving)
                }
            }
        }
    }
    
    // MARK: - Sections
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("오늘의 감정을 기록해볼까요?")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(AppColor.textPrimary)
            
            Text("지금 느끼는 감정과 떠오르는 생각들을 편하게 적어주세요.")
                .font(.system(size: 13))
                .foregroundColor(AppColor.textSecondary)
        }
    }
    
    private var emojiSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("오늘의 감정")
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(AppColor.textPrimary)
            
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(AppColor.background)
                        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
                    
                    Text(viewModel.emotion)
                        .font(.system(size: 32))
                }
                .frame(width: 64, height: 64)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(emojiOptions, id: \.self) { emoji in
                            Button {
                                viewModel.emotion = emoji
                            } label: {
                                Text(emoji)
                                    .font(.system(size: 26))
                                    .padding(10)
                                    .background(
                                        Circle()
                                            .fill(viewModel.emotion == emoji
                                                  ? AppColor.primary.opacity(0.15)
                                                  : Color.white.opacity(0.9))
                                    )
                                    .overlay(
                                        Circle()
                                            .stroke(viewModel.emotion == emoji
                                                    ? AppColor.primary
                                                    : Color.clear, lineWidth: 1)
                                    )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
        }
    }
    
    private var titleSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("감정 한 줄 제목")
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(AppColor.textPrimary)
            
            TextField("예: 평온한 하루", text: $viewModel.title)
                .font(.system(size: 15))
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white.opacity(0.95))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.black.opacity(0.03), lineWidth: 1)
                )
        }
    }
    
    private var contentSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("내용")
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(AppColor.textPrimary)
            
            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white.opacity(0.95))
                    .shadow(color: Color.black.opacity(0.02), radius: 6, x: 0, y: 3)
                
                TextEditor(text: $viewModel.content)
                    .font(.system(size: 15))
                    .padding(12)
                    .scrollContentBackground(.hidden)
                
                if viewModel.content.isEmpty {
                    Text("오늘 있었던 일이나 느낀 점을 자유롭게 적어보세요.")
                        .font(.system(size: 14))
                        .foregroundColor(AppColor.textSecondary)
                        .padding(19)
                }
            }
            .frame(minHeight: 160)
        }
    }
}
