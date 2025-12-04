//
//  EmotionRecordWriteView.swift
//  HaruDam
//
//  Created by 존진 on 12/4/25.
//  Copyright © 2025 kr.co.HaruDam. All rights reserved.
//

import SwiftUI

struct EmotionRecordWriteView: View {

    @Environment(\.dismiss) private var dismiss

    @State private var selectedEmoji: String = "😌"
    @State private var title: String = ""
    @State private var date: Date = Date()
    @State private var content: String = ""

    /// 저장 버튼 눌렀을 때 상위에서 처리할 수 있도록 콜백
    var onSave: ((String, String, Date, String) -> Void)?

    private let emojiOptions: [String] = ["😌", "😊", "😢", "😡", "😰", "🤔", "🥰", "🤯"]

    var body: some View {
        NavigationStack {
            ZStack {
                AppColor.background.ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 24) {

                        headerSection
                        emojiSection
                        dateSection
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
                        handleSave()
                    }
                    .foregroundColor(canSave ? AppColor.primary : AppColor.textSecondary)
                    .disabled(!canSave)
                }
            }
        }
    }

    // 저장 가능 여부
    private var canSave: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
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

                    Text(selectedEmoji)
                        .font(.system(size: 32))
                }
                .frame(width: 64, height: 64)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(emojiOptions, id: \.self) { emoji in
                            Button {
                                selectedEmoji = emoji
                            } label: {
                                Text(emoji)
                                    .font(.system(size: 26))
                                    .padding(10)
                                    .background(
                                        Circle()
                                            .fill(selectedEmoji == emoji
                                                  ? AppColor.primary.opacity(0.15)
                                                  : Color.white.opacity(0.9))
                                    )
                                    .overlay(
                                        Circle()
                                            .stroke(selectedEmoji == emoji
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

    private var dateSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("날짜")
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(AppColor.textPrimary)

            DatePicker(
                "",
                selection: $date,
                displayedComponents: .date
            )
            .labelsHidden()
            .tint(AppColor.primary)
        }
    }

    private var titleSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("감정 한 줄 제목")
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(AppColor.textPrimary)

            TextField("예: 평온한 하루", text: $title)
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

                TextEditor(text: $content)
                    .font(.system(size: 15))
                    .padding(12)
                    .scrollContentBackground(.hidden)

                if content.isEmpty {
                    Text("오늘 있었던 일이나 느낀 점을 자유롭게 적어보세요.")
                        .font(.system(size: 14))
                        .foregroundColor(AppColor.textSecondary)
                        .padding(19)
                }
            }
            .frame(minHeight: 160)
        }
    }

    // MARK: - 저장
    private func handleSave() {
        guard canSave else { return }
        onSave?(selectedEmoji, title, date, content)
        dismiss()
    }
}

#Preview {
    EmotionRecordWriteView()
}
