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
    
    let record: EmotionRecordEntity
    
    @State private var title: String
    @State private var content: String
    @State private var emotion: String
    
    init(record: EmotionRecordEntity) {
        self.record = record
        _title = State(initialValue: record.title ?? "")
        _content = State(initialValue: record.content ?? "")
        _emotion = State(initialValue: record.emotion ?? "🙂")
    }
    
    var body: some View {
        VStack(spacing: 16) {
            // 감정(이모지) — 지금은 Text로, 나중에 Picker로 확장 가능
            TextField("감정", text: $emotion)
                .font(.system(size: 32))
                .multilineTextAlignment(.center)
            
            TextField("제목", text: $title)
                .textFieldStyle(.roundedBorder)
            
            TextEditor(text: $content)
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
                    updateRecord()
                }
                .disabled(title.isEmpty || content.isEmpty)
            }
        }
    }
    
    private func updateRecord() {
        record.title = title
        record.content = content
        record.emotion = emotion
        record.updatedAt = Date()
        
        do {
            try context.save()
            dismiss()
        } catch {
            context.rollback()
            print("Failed to update record:", error)
        }
    }
}
