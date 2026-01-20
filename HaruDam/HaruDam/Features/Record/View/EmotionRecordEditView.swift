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
        VStack(spacing: 16) {
            // 감정(이모지) — 지금은 Text로, 나중에 Picker로 확장 가능
            TextField("감정", text: $viewModel.emotion)
                .font(.system(size: 32))
                .multilineTextAlignment(.center)
            
            TextField("제목", text: $viewModel.title)
                .textFieldStyle(.roundedBorder)
            
            TextEditor(text: $viewModel.content)
                .frame(minHeight: 200)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.2))
                )
            
            Spacer()
        }
        .padding()
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
                .disabled(!viewModel.canSave || viewModel.isSyncing)
            }
        }
    }
}
