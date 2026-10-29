//
//  MillionCelebrationView.swift
//  Zeka
//
//  Created by admin on 30.10.26.
//

import SwiftUI

struct MillionCelebrationView: View {
    @Environment(\.accessibilityReduceMotion)
    private var reduceMotion

    var body: some View {
        VStack(spacing: 18) {
            Image(systemName: "crown.fill")
                .font(.system(size: 76))
                .foregroundStyle(.yellow)
                .symbolEffect(
                    .bounce,
                    options: .repeating,
                    isActive: !reduceMotion
                )
                .accessibilityHidden(true)

            Text("MİLYONÇU OLDUN!")
                .font(
                    .system(
                        .title,
                        design: .rounded,
                        weight: .heavy
                    )
                )
                .multilineTextAlignment(.center)
                .foregroundStyle(.white)

            Text(PrizeFormatter.string(from: 1_000_000))
                .font(
                    .system(
                        .largeTitle,
                        design: .rounded,
                        weight: .bold
                    )
                )
                .foregroundStyle(.yellow)
                .minimumScaleFactor(0.6)
                .lineLimit(1)

            Text("15 sual, 15 düzgün cavab. Zirvəyə çatdın!")
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundStyle(AppTheme.secondaryText)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .overlay {
            if !reduceMotion {
                ConfettiView()
            }
        }
        .clipped()
    }
}

#Preview {
    MillionCelebrationView()
        .padding(24)
        .background(AppTheme.background)
        .preferredColorScheme(.dark)
}
