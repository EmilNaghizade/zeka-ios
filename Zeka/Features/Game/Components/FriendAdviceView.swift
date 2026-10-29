//
//  FriendAdviceView.swift
//  Zeka
//
//  Created by admin on 30.10.26.
//

import SwiftUI

struct FriendAdviceView: View {
    let answer: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label(
                "Dostunun tövsiyəsi",
                systemImage: "phone.fill"
            )
            .font(.headline)
            .foregroundStyle(AppTheme.accent)

            Text("Məncə, düzgün cavab “\(answer)” variantıdır.")
                .font(.body)
                .foregroundStyle(.white)

            Text("Virtual dostun tövsiyəsi səhv ola bilər.")
                .font(.caption)
                .foregroundStyle(AppTheme.secondaryText)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(22)
        .background(
            AppTheme.surface,
            in: RoundedRectangle(cornerRadius: 20)
        )
    }
}

#Preview {
    FriendAdviceView(answer: "Yupiter")
        .padding(24)
        .background(AppTheme.background)
}
