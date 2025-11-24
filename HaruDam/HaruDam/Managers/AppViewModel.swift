//
//  AppViewModel.swift
//  HaruDam
//
//  Created by 존진 on 11/24/25.
//

import Foundation
import Combine

@MainActor
final class AppViewModel: ObservableObject {
    @Published var isLoggedIn: Bool = false
}
