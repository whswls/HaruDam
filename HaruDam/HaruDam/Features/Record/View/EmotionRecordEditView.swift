//
//  EmotionRecordEditView.swift
//  HaruDam
//
//  Created by 존진 on 1/16/26.
//  Copyright © 2026 kr.co.HaruDam. All rights reserved.
//

import SwiftUI
import CoreData

struct EmotionRecordEditView: View {
    @Environment(\.managedObjectContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    @StateObject private var viewModel: EmotionRecordEditViewModel
    
    init(record: EmotionRecordEntity) {
        _viewModel = StateObject(wrappedValue: EmotionRecordEditViewModel(record: record))
    }
    
    var body: some View {
        ZStack {
            AppColor.background.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 24) {
                    headerSection
                    emojiSection
                    titleSection
                    contentSection

                    Spacer(minLength: 0)
                }
                .padding(.horizontal, 20)
                .padding(.top, 24)
                .padding(.bottom, 40)
            }
        }
        .navigationTitle("감정 기록 수정")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("완료") {
                    Task {
                        await viewModel.save(context: context)
                        if viewModel.errorMessage == nil {
                            dismiss()
                        }
                    }
                }
                .foregroundColor(viewModel.canSave ? AppColor.primary : AppColor.textSecondary)
                .disabled(!viewModel.canSave || viewModel.isSyncing)
            }
        }
    }
    
    // MARK: - Sections
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("기록을 수정해볼까요?")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(AppColor.textPrimary)

            Text("감정과 내용을 원하는 대로 바꿔볼 수 있어요.")
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
                        ForEach(["😌", "😊", "😢", "😡", "😰", "🤔", "🥰", "🤯"], id: \.self) { emoji in
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

            TextField("제목을 입력해주세요", text: $viewModel.title)
                .font(.system(size: 15))
                .foregroundColor(AppColor.textPrimary)
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
                    .foregroundColor(AppColor.textPrimary)
                    .padding(12)
                    .scrollContentBackground(.hidden)

                if viewModel.content.isEmpty {
                    Text("오늘 있었던 일이나 느낀 점을 자유롭게 적어보세요.")
                        .font(.system(size: 14))
                        .foregroundColor(AppColor.textSecondary)
                        .padding(19)
                }
            }
            .frame(minHeight: 200)
        }
    }
}
