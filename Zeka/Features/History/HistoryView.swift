import SwiftUI
import SwiftData

struct HistoryView: View {
    @Query(
        sort: \GameResult.playedAt,
        order: .reverse
    )
    private var results: [GameResult]

    var body: some View {
        ZStack {
            AppTheme.background
                .ignoresSafeArea()

            if results.isEmpty {
                ContentUnavailableView(
                    "Hələ oyun yoxdur",
                    systemImage: "clock",
                    description: Text(
                        "Tamamladığın oyunlar burada görünəcək."
                    )
                )
            } else {
                ScrollView {
                    LazyVStack(spacing: 14) {
                        ForEach(results) { result in
                            NavigationLink {
                                GameResultDetailView(result: result)
                            } label: {
                                historyCard(for: result)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(24)
                    .frame(maxWidth: 560)
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .navigationTitle("Oyun tarixçəsi")
        .navigationBarTitleDisplayMode(.inline)
        .preferredColorScheme(.dark)
    }

    private func historyCard(
        for result: GameResult
    ) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .top, spacing: 12) {
                Text(PrizeFormatter.string(from: result.prize))
                    .font(.title2.bold())
                    .foregroundStyle(AppTheme.accent)

                Spacer()

                Text(result.outcomeTitle)
                    .font(.caption)
                    .foregroundStyle(AppTheme.secondaryText)
                    .multilineTextAlignment(.trailing)
            }

            Text(
                "Düzgün cavab: \(result.correctAnswerCount)"
                + " / \(result.totalQuestionCount)"
            )
            .font(.subheadline)
            .foregroundStyle(.white)

            Text(
                result.playedAt,
                format: .dateTime
                    .day()
                    .month()
                    .year()
                    .hour()
                    .minute()
            )
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
    NavigationStack {
        HistoryView()
    }
    .modelContainer(
        for: GameResult.self,
        inMemory: true
    )
}
