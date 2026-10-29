//
//  AnswerButtonView.swift
//  Zeka
//
//  Created by admin on 30.10.26.
//

import SwiftUI

struct AnswerButtonView: View {
    let letter: String
    let answer: String
    let color: Color
    let showsCorrectIcon: Bool
    let showsWrongIcon: Bool
    let isDisabled: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Text(letter)
                    .font(.subheadline.bold())
                    .frame(width: 36, height: 36)
                    .background(
                        .white.opacity(0.08),
                        in: RoundedRectangle(cornerRadius: 10)
                    )

                Text(answer)
                    .font(.body.weight(.medium))
                    .multilineTextAlignment(.leading)

                Spacer(minLength: 0)

                if showsCorrectIcon {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.green)
                } else if showsWrongIcon {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.red)
                }
            }
            .foregroundStyle(.white)
            .padding(18)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                color.opacity(0.15),
                in: RoundedRectangle(cornerRadius: 18)
            )
            .overlay {
                RoundedRectangle(cornerRadius: 18)
                    .strokeBorder(
                        color.opacity(0.6),
                        lineWidth: 1
                    )
            }
            .contentShape(
                RoundedRectangle(cornerRadius: 18)
            )
        }
        .buttonStyle(.plain)
        .disabled(isDisabled)
    }
}

#Preview {
    AnswerButtonView(
        letter: "A",
        answer: "Yupiter",
        color: AppTheme.accent,
        showsCorrectIcon: false,
        showsWrongIcon: false,
        isDisabled: false
    ) {}
    .padding(24)
    .background(AppTheme.background)
}
