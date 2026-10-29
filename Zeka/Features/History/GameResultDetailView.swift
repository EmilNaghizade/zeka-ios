//
//  GameResultDetailView.swift
//  Zeka
//
//  Created by admin on 30.10.26.
//

import SwiftUI
import SwiftData

struct GameResultDetailView: View {
    let result: GameResult

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Image(
                    systemName: result.isMillionWinner
                        ? "crown.fill"
                        : "trophy.fill"
                )
                .font(.system(size: 56))
                .foregroundStyle(
                    result.isMillionWinner
                        ? Color.yellow
                        : AppTheme.accent
                )
                .accessibilityHidden(true)

                Text(result.outcomeTitle)
                    .font(.title.bold())
                    .foregroundStyle(.white)

                detailRow(
                    title: "Virtual mükafat",
                    value: PrizeFormatter.string(from: result.prize)
                )

                detailRow(
                    title: "Düzgün cavab",
                    value: "\(result.correctAnswerCount)"
                        + " / \(result.totalQuestionCount)"
                )

                VStack(alignment: .leading, spacing: 8) {
                    Text("Oyun tarixi")
                        .foregroundStyle(AppTheme.secondaryText)

                    Text(
                        result.playedAt,
                        format: .dateTime
                            .day()
                            .month()
                            .year()
                            .hour()
                            .minute()
                    )
                    .foregroundStyle(.white)
                }
                .font(.subheadline)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(24)
            .background(
                AppTheme.surface,
                in: RoundedRectangle(cornerRadius: 24)
            )
            .padding(24)
            .frame(maxWidth: 560)
            .frame(maxWidth: .infinity)
        }
        .background(AppTheme.background)
        .navigationTitle("Oyun nəticəsi")
        .navigationBarTitleDisplayMode(.inline)
        .preferredColorScheme(.dark)
    }

    private func detailRow(
        title: String,
        value: String
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline)
                .foregroundStyle(AppTheme.secondaryText)

            Text(value)
                .font(.title2.bold())
                .foregroundStyle(.white)
        }
    }
}
