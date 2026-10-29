//
//  HomeView.swift
//  Zeka
//
//  Created by admin on 29.10.26.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @Query private var results: [GameResult]

    private var highestPrize: Int {
        results.map { $0.prize }.max() ?? 0
    }
    
    private var millionWinCount: Int {
        results.filter { $0.isMillionWinner }.count
    }

    var body: some View {
        ZStack {
            AppTheme.background
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 32) {
                    header
                    welcomeCard
                    statisticsSection
                    NavigationLink {
                        HistoryView()
                    } label: {
                        HStack {
                            Label(
                                "Oyun tarixçəsi",
                                systemImage: "clock.arrow.circlepath"
                            )

                            Spacer()

                            Image(systemName: "chevron.right")
                        }
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(AppTheme.accent)
                        .padding(20)
                        .background(
                            AppTheme.surface,
                            in: RoundedRectangle(cornerRadius: 18)
                        )
                    }
                    .buttonStyle(.plain)
                    gameInfo
                    startButton
                    NavigationLink {
                        RulesView()
                    } label: {
                        Label(
                            "Necə oynanılır?",
                            systemImage: "questionmark.circle"
                        )
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(AppTheme.secondaryText)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                    }
                    NavigationLink {
                        SettingsView()
                    } label: {
                        Label("Parametrlər", systemImage: "gearshape")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(AppTheme.secondaryText)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                    }
                    footer
                    
                }
                .padding(
                    .horizontal,
                    AppTheme.horizontalPadding
                )
                .padding(.top, 24)
                .padding(.bottom, 32)
                .frame(maxWidth: 560)
                .frame(maxWidth: .infinity)
            }
        }
        .preferredColorScheme(.dark)
    }

    private var header: some View {
        HStack {
            HStack(spacing: 10) {
                Image(systemName: "sparkles")
                    .foregroundStyle(AppTheme.accent)
                    .accessibilityHidden(true)

                Text("Zəka")
                    .foregroundStyle(.white)
            }
            .font(.title2.bold())

            Spacer()

            Text("BİLİK OYUNU")
                .font(.caption2.bold())
                .tracking(2)
                .foregroundStyle(AppTheme.secondaryText)
        }
    }

    private var welcomeCard: some View {
        VStack(alignment: .leading, spacing: 24) {
            Image(systemName: "brain")
                .font(.system(size: 44))
                .foregroundStyle(.white)
                .padding(20)
                .background(
                    AppTheme.accent.opacity(0.20),
                    in: RoundedRectangle(cornerRadius: 24)
                )
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 12) {
                Text("Hər sual\nbir addım irəli.")
                    .font(
                        .system(
                            .largeTitle,
                            design: .rounded,
                            weight: .bold
                        )
                    )
                    .foregroundStyle(.white)
                    .fixedSize(horizontal: false, vertical: true)

                Text(
                    "Biliklərini sına, sualları keç "
                    + "və öz rekordunu yarat."
                )
                .font(.body)
                .foregroundStyle(AppTheme.secondaryText)
                .lineSpacing(4)
            }

            Label(
                results.isEmpty
                    ? "İlk rekordunu yarat"
                    : "Rekordun: "
                        + PrizeFormatter.string(from: highestPrize),
                systemImage: "trophy"
            )
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(AppTheme.accent)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(28)
        .background(
            AppTheme.surface,
            in: RoundedRectangle(
                cornerRadius: AppTheme.cornerRadius
            )
        )
        .overlay {
            RoundedRectangle(
                cornerRadius: AppTheme.cornerRadius
            )
            .strokeBorder(.white.opacity(0.06), lineWidth: 1)
        }
    }
    private var statisticsSection: some View {
        VStack(spacing: 16) {
            HStack(spacing: 16) {
                statisticCard(
                    title: "Oyun sayı",
                    value: "\(results.count)",
                    icon: "gamecontroller.fill"
                )

                statisticCard(
                    title: "Ən yüksək mükafat",
                    value: PrizeFormatter.string(from: highestPrize),
                    icon: "trophy.fill"
                )
            }

            statisticCard(
                title: "Milyonluq qələbə",
                value: "\(millionWinCount)",
                icon: "crown.fill"
            )
        }
    }

    private func statisticCard(
        title: String,
        value: String,
        icon: String
    ) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Image(systemName: icon)
                .foregroundStyle(AppTheme.accent)

            Text(value)
                .font(.title2.bold())
                .foregroundStyle(.white)

            Text(title)
                .font(.caption)
                .foregroundStyle(AppTheme.secondaryText)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(
            AppTheme.surface,
            in: RoundedRectangle(cornerRadius: 20)
        )
    }

    private var gameInfo: some View {
        ViewThatFits(in: .horizontal) {
            HStack(spacing: 12) {
                infoItem(
                    icon: "questionmark.circle",
                    title: "15 sual"
                )

                infoItem(
                    icon: "square.grid.2x2",
                    title: "4 variant"
                )

                infoItem(
                    icon: "bolt",
                    title: "3 kömək"
                )
            }

            VStack(alignment: .leading, spacing: 16) {
                infoItem(
                    icon: "questionmark.circle",
                    title: "15 sual"
                )

                infoItem(
                    icon: "square.grid.2x2",
                    title: "4 variant"
                )

                infoItem(
                    icon: "bolt",
                    title: "2 kömək"
                )
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            AppTheme.surface,
            in: RoundedRectangle(cornerRadius: 20)
        )
    }

    private var startButton: some View {
        NavigationLink {
            GameView()
        } label: {
            HStack(spacing: 12) {
                Text("Oyuna başla")

                Spacer()

                Image(systemName: "arrow.right")
            }
            .font(.headline)
            .foregroundStyle(.white)
            .padding(22)
            .frame(maxWidth: .infinity)
            .background(
                LinearGradient(
                    colors: [
                        AppTheme.accent,
                        Color(
                            red: 0.35,
                            green: 0.28,
                            blue: 0.85
                        )
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                ),
                in: RoundedRectangle(cornerRadius: 20)
            )
        }
        .buttonStyle(.plain)
    }
    
    

    private var footer: some View {
        Text("Böyük nəticələr bir sualla başlayır.")
            .font(.footnote)
            .foregroundStyle(AppTheme.secondaryText)
            .frame(maxWidth: .infinity)
            .multilineTextAlignment(.center)
    }

    private func infoItem(
        icon: String,
        title: String
    ) -> some View {
        Label(title, systemImage: icon)
            .font(.subheadline.weight(.medium))
            .foregroundStyle(AppTheme.secondaryText)
            .fixedSize()
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    NavigationStack {
        HomeView()
    }
    .modelContainer(
        for: GameResult.self,
        inMemory: true
    )
}
