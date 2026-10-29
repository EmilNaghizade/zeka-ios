//
//  QuestionCardView.swift
//  Zeka
//
//  Created by admin on 30.10.26.
//

import SwiftUI

struct QuestionCardView: View {
    let text: String

    var body: some View {
        Text(text)
            .font(
                .system(
                    .title2,
                    design: .rounded,
                    weight: .bold
                )
            )
            .foregroundStyle(.white)
            .fixedSize(horizontal: false, vertical: true)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(28)
            .background(
                AppTheme.surface,
                in: RoundedRectangle(
                    cornerRadius: AppTheme.cornerRadius
                )
            )
    }
}

#Preview {
    QuestionCardView(
        text: "Günəş sistemində ən böyük planet hansıdır?"
    )
    .padding(24)
    .background(AppTheme.background)
}
