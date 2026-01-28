//
//  ProfileViewModel.swift
//  HaruDam
//
//  Created by 존진 on 1/29/26.
//  Copyright © 2026 kr.co.HaruDam. All rights reserved.
//

import Foundation

@MainActor
final class ProfileViewModel: ObservableObject {
    @Published var summary = ProfileSummaryDTO(
        totalRecords: 0, streakDays: 0, mostFrequentEmotion: "-")
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let service: ProfileServiceProtocol
    
    init(service: ProfileServiceProtocol) {
        self.service = service
    }
    
    func load(userId: UUID) async {
        isLoading = true
        errorMessage = nil
        
        defer { isLoading = false }
        
        do {
            summary = try await service.fetchProfileSummary(userId: userId)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
