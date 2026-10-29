//
//  RulesView.swift
//  Zeka
//
//  Created by admin on 30.10.26.
//

import SwiftUI

struct RulesView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                ruleSection(
                    title: "Məqsəd",
                    text: """
                    15 suala düzgün cavab verərək \
                    1 000 000 ₼ virtual mükafat qazan.
                    """
                )

                ruleSection(
                    title: "Cavab seçimi",
                    text: """
                    Dörd variantdan birini seç və \
                    “Son qərarım” düyməsi ilə təsdiqlə. \
                    Təsdiqdən sonra cavabı dəyişmək olmaz.
                    """
                )

                ruleSection(
                    title: "Təminatlı mükafatlar",
                    text: """
                    5-ci suala düzgün cavab: 1 000 ₼.
                    10-cu suala düzgün cavab: 32 000 ₼.

                    Sonrakı sualda səhv etsən, çatdığın \
                    son təminatlı məbləği saxlayırsan. \
                    İlk təminat həddindən əvvəl səhv \
                    cavab versən, yekun mükafat 0 ₼ olur.
                    """
                )

                ruleSection(
                    title: "Üç kömək",
                    text: """
                    50:50 — iki yanlış variantı gizlədir.

                    Tamaşaçılar — simulyasiya edilmiş \
                    səs bölgüsünü göstərir.

                    Dosta zəng — virtual dost cavab \
                    tövsiyə edir. Tövsiyə səhv ola bilər.

                    Hər köməkdən bir oyun ərzində \
                    yalnız bir dəfə istifadə edə bilərsən.
                    """
                )

                ruleSection(
                    title: "Oyundan çəkilmək",
                    text: """
                    Cavabı təsdiqləməmiş oyundan \
                    çəkilə bilərsən. Bu halda son düzgün \
                    cavabla qazandığın məbləği saxlayırsan.
                    """
                )

                ruleSection(
                    title: "Virtual mükafat",
                    text: """
                    Göstərilən məbləğlər oyun nəticəsidir. \
                    Real pul ödənişi edilmir.
                    """
                )
            }
            .padding(24)
            .frame(maxWidth: 560)
            .frame(maxWidth: .infinity)
        }
        .background(AppTheme.background)
        .navigationTitle("Oyun qaydaları")
        .navigationBarTitleDisplayMode(.inline)
        .preferredColorScheme(.dark)
    }

    private func ruleSection(
        title: String,
        text: String
    ) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .foregroundStyle(AppTheme.accent)

            Text(text)
                .font(.body)
                .foregroundStyle(.white)
                .lineSpacing(5)
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
        RulesView()
    }
}
