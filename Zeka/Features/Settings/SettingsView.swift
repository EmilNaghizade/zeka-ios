//
//  SettingsView.swift
//  Zeka
//
//  Created by admin on 30.10.26.
//

import SwiftUI
import UIKit

struct SettingsView: View {
    @AppStorage("hapticsEnabled")
    private var hapticsEnabled = true

    var body: some View {
        Form {
            Section("Oyun") {
                Toggle(
                    "Vibrasiya",
                    isOn: $hapticsEnabled
                )
                Button("Vibrasiyanı yoxla") {
                    let generator = UINotificationFeedbackGenerator()
                    generator.prepare()
                    generator.notificationOccurred(.success)
                }
                .tint(AppTheme.accent)
            }
        }
        .scrollContentBackground(.hidden)
        .background(AppTheme.background)
        .navigationTitle("Parametrlər")
        .navigationBarTitleDisplayMode(.inline)
        .preferredColorScheme(.dark)
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
}
