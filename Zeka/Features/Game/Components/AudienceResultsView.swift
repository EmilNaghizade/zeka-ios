//
//  AudienceResultsView.swift
//  Zeka
//
//  Created by admin on 30.10.26.
//

import SwiftUI

struct AudienceResultsView: View {
    let percentages: [Int]

    private let letters = ["A", "B", "C", "D"]

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            Label(
                "Tamaşaçıların seçimi",
                systemImage: "person.3.fill"
            )
            .font(.headline)
            .foregroundStyle(.white)

            Text("Simulyasiya edilmiş səsvermə")
                .font(.caption)
                .foregroundStyle(AppTheme.secondaryText)

            ForEach(
                Array(percentages.enumerated()),
                id: \.offset
            ) { item in
                VStack(spacing: 8) {
                    HStack {
                        Text(
                            letters.indices.contains(item.offset)
                                ? letters[item.offset]
                                : "\(item.offset + 1)"
                        )

                        Spacer()

                        Text("\(item.element)%")
                    }
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.white)

                    ProgressView(
                        value: Double(item.element),
                        total: 100
                    )
                    .tint(AppTheme.accent)
                }
            }
        }
        .padding(22)
        .background(
            AppTheme.surface,
            in: RoundedRectangle(cornerRadius: 20)
        )
    }
}

#Preview {
    AudienceResultsView(
        percentages: [10, 65, 15, 10]
    )
    .padding(24)
    .background(AppTheme.background)
}
