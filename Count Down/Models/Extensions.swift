//
//  Extensions.swift
//  Count Down
//
//  Created by Lesha Melnichenko on 30.12.2023.
//

import Foundation
import SwiftUI

extension View {
    func configureNavigationBar(title: String) -> some View{
        self
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(K.Colors.primary2, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
    }
}

extension Timer {
    var isPaused: Bool {
        fireDate > .farEnough
    }
    func pause() {
        if !isPaused {
            fireDate = .farEnough + (fireDate - Date())
        }
    }
    func resume() {
        if isPaused {
            fireDate = Date() + (fireDate - .farEnough)
        }
    }
}

extension Date {
    static let farEnough = Date(timeIntervalSince1970: 100*365*24*60*60)
    static func - (a: Self, b: Self) -> TimeInterval {
        a.timeIntervalSince(b)
    }
}

