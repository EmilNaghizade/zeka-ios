//
//  LifelineButtonView.swift
//  Zeka
//
//  Created by admin on 30.10.26.
//

import SwiftUI

struct LifelineButtonView: View {
    let title: String
    let icon: String
    let isUsed: Bool
    let isDisabled: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.title3)

                Text(title)
                    .font(.caption.weight(.semibold))
                    .multilineTextAlignment(.center)
            }
            .foregroundStyle(
                isUsed
                    ? AppTheme.secondaryText
                    : AppTheme.accent
            )
            .frame(maxWidth: .infinity)
            .frame(minHeight: 84)
            .background(
                AppTheme.surface,
                in: RoundedRectangle(cornerRadius: 16)
            )
            .opacity(isUsed ? 0.4 : 1)
        }
        .buttonStyle(.plain)
        .disabled(isUsed || isDisabled)
    }
}

#Preview {
    HStack(spacing: 12) {
        LifelineButtonView(
            title: "50:50",
            icon: "circle.lefthalf.filled",
            isUsed: false,
            isDisabled: false
        ) {}

        LifelineButtonView(
            title: "Tamaşaçılar",
            icon: "person.3.fill",
            isUsed: true,
            isDisabled: false
        ) {}
    }
    .padding(24)
    .background(AppTheme.background)
}
