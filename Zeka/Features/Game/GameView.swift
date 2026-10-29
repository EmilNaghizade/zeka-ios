import SwiftUI
import SwiftData

struct GameView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    @State private var game = GameViewModel()
    @State private var showsWalkAwayConfirmation = false
    @State private var showsPrizeLadder = false
    @State private var hasSavedResult = false
    @State private var savingError: String?

    @AppStorage("hapticsEnabled")
    private var hapticsEnabled = true

    private let answerLetters = ["A", "B", "C", "D"]

    var body: some View {
        ZStack {
            AppTheme.background
                .ignoresSafeArea()

            ScrollViewReader { proxy in
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        if let question = game.currentQuestion {
                            prizeHeader
                                .id("top")

                            prizeLadderButton
                            lifelinesSection
                            categoryHeader(for: question)
                            QuestionCardView(text: question.text)
                            answersSection(for: question)

                            if !game.audiencePercentages.isEmpty {
                                AudienceResultsView(
                                    percentages: game.audiencePercentages
                                )
                            }

                            if let index = game.friendSuggestedAnswerIndex,
                               question.answers.indices.contains(index) {
                                FriendAdviceView(
                                    answer: question.answers[index]
                                )
                            }

                            if game.selectedAnswerIndex != nil {
                                feedbackCard(for: question)
                            }

                            if game.isGameOver {
                                resultCard
                                    .id("result")
                            } else if game.selectedAnswerIndex == nil {
                                answerActions
                            }
                        } else {
                            loadingFailure
                        }
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
                .onChange(of: game.isGameOver) { _, isGameOver in
                    if isGameOver {
                        withAnimation {
                            proxy.scrollTo("result", anchor: .center)
                        }
                    }
                }
                .onChange(of: game.currentQuestionIndex) { _, _ in
                    if !game.isGameOver {
                        withAnimation {
                            proxy.scrollTo("top", anchor: .top)
                        }
                    }
                }
            }
        }
        .navigationTitle("Oyun")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .preferredColorScheme(.dark)
        .sensoryFeedback(
            .success,
            trigger: game.correctAnswerCount
        ) { oldCount, newCount in
            hapticsEnabled && newCount > oldCount
        }
        .sensoryFeedback(
            .error,
            trigger: game.isGameOver
        ) { _, isGameOver in
            hapticsEnabled
                && isGameOver
                && !game.didWalkAway
                && !game.isAnswerCorrect
        }
        .task(id: game.selectedAnswerIndex) {
            guard game.selectedAnswerIndex != nil,
                  game.isAnswerCorrect,
                  !game.isGameOver else {
                return
            }

            do {
                try await Task.sleep(for: .milliseconds(1500))
            } catch {
                return
            }

            guard !Task.isCancelled else {
                return
            }

            withAnimation(.easeInOut(duration: 0.2)) {
                game.nextQuestion()
            }
        }
        .onChange(of: game.result?.id) { _, _ in
            saveResult()
        }
        .sheet(isPresented: $showsPrizeLadder) {
            prizeLadderSheet
        }
        .alert(
            "Oyundan çəkilmək istəyirsən?",
            isPresented: $showsWalkAwayConfirmation
        ) {
            Button("Oyuna davam et", role: .cancel) {}

            Button("Çəkil", role: .destructive) {
                game.walkAway()
            }
        } message: {
            Text(
                "Oyunu "
                + PrizeFormatter.string(from: game.earnedPrize)
                + " virtual mükafatla bitirəcəksən."
            )
        }
    }

    // MARK: - Oyun başlığı

    private var prizeHeader: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(
                "Sual \(game.currentQuestionIndex + 1)"
                + " / \(game.questions.count)"
            )
            .font(.subheadline)
            .foregroundStyle(AppTheme.secondaryText)
            
            ProgressView(
                value: Double(game.correctAnswerCount),
                total: Double(max(game.questions.count, 1))
            )
            .tint(AppTheme.accent)
            .accessibilityLabel("Oyun irəliləyişi")
            .accessibilityValue(
                "\(game.questions.count) sualdan "
                + "\(game.correctAnswerCount) düzgün cavab"
            )
            
            Text(
                "Sualın dəyəri: "
                + PrizeFormatter.string(from: game.currentPrize)
            )
            .font(.title2.bold())
            .foregroundStyle(AppTheme.accent)

            Text(
                "Qazandığın: "
                + PrizeFormatter.string(from: game.earnedPrize)
            )
            .font(.subheadline)
            .foregroundStyle(AppTheme.secondaryText)

            Text("Virtual oyun məbləğidir.")
                .font(.caption)
                .foregroundStyle(AppTheme.secondaryText)
        }
    }

    private var prizeLadderButton: some View {
        Button {
            showsPrizeLadder = true
        } label: {
            Label(
                "Mükafat pillələri",
                systemImage: "list.number"
            )
            .font(.subheadline.weight(.semibold))
            .foregroundStyle(AppTheme.accent)
        }
    }

    private func categoryHeader(
        for question: Question
    ) -> some View {
        HStack {
            Label(
                question.category,
                systemImage: "square.grid.2x2"
            )

            Spacer()

            Text(question.difficultyTitle)
                .font(.caption.weight(.semibold))
                .foregroundStyle(
                    difficultyColor(for: question.difficulty)
                )
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    difficultyColor(for: question.difficulty)
                        .opacity(0.12),
                    in: Capsule()
                )
        }
        .font(.subheadline.weight(.medium))
        .foregroundStyle(AppTheme.secondaryText)
    }

    private func difficultyColor(for level: Int) -> Color {
        switch level {
        case 1:
            return .green
        case 2:
            return .orange
        default:
            return AppTheme.accent
        }
    }

    // MARK: - Sual və cavablar

    
    private func answersSection(
        for question: Question
    ) -> some View {
        VStack(spacing: 14) {
            ForEach(question.answers.indices, id: \.self) { index in
                if !game.hiddenAnswerIndices.contains(index) {
                    answerButton(at: index, for: question)
                }
            }
        }
    }

    private func answerButton(
        at index: Int,
        for question: Question
    ) -> some View {
        AnswerButtonView(
            letter: answerLetter(at: index),
            answer: question.answers[index],
            color: answerColor(at: index, for: question),
            showsCorrectIcon:
                game.selectedAnswerIndex != nil
                && index == question.correctAnswerIndex,
            showsWrongIcon:
                game.selectedAnswerIndex != nil
                && index == game.selectedAnswerIndex
                && index != question.correctAnswerIndex,
            isDisabled:
                game.selectedAnswerIndex != nil
                || game.isGameOver
        ) {
            withAnimation(.easeInOut(duration: 0.2)) {
                game.chooseAnswer(at: index)
            }
        }
    }

    private func answerLetter(at index: Int) -> String {
        answerLetters.indices.contains(index)
            ? answerLetters[index]
            : "\(index + 1)"
    }

    private func answerColor(
        at index: Int,
        for question: Question
    ) -> Color {
        guard game.selectedAnswerIndex != nil else {
            return index == game.pendingAnswerIndex
                ? AppTheme.accent
                : AppTheme.secondaryText
        }

        if index == question.correctAnswerIndex {
            return .green
        }

        if index == game.selectedAnswerIndex {
            return .red
        }

        return AppTheme.secondaryText
    }

    private var answerActions: some View {
        VStack(spacing: 16) {
            if game.pendingAnswerIndex != nil {
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        game.confirmAnswer()
                    }
                } label: {
                    Text("Son qərarım")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(20)
                        .background(
                            AppTheme.accent,
                            in: RoundedRectangle(cornerRadius: 18)
                        )
                }
                .buttonStyle(.plain)
            }

            Button("Oyundan çəkil") {
                showsWalkAwayConfirmation = true
            }
            .font(.subheadline.weight(.semibold))
            .foregroundStyle(AppTheme.secondaryText)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
        }
    }

    private func feedbackCard(
        for question: Question
    ) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Label(
                game.isAnswerCorrect
                    ? "Düzgün cavab!"
                    : "Bu dəfə alınmadı",
                systemImage: game.isAnswerCorrect
                    ? "checkmark.circle.fill"
                    : "info.circle.fill"
            )
            .font(.headline)
            .foregroundStyle(
                game.isAnswerCorrect ? Color.green : Color.orange
            )

            Text(question.explanation)
                .font(.subheadline)
                .foregroundStyle(AppTheme.secondaryText)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(22)
        .background(
            AppTheme.surface,
            in: RoundedRectangle(cornerRadius: 20)
        )
    }

    // MARK: - Köməklər

    private var lifelinesSection: some View {
        HStack(spacing: 12) {
            lifelineButton(
                title: "50:50",
                icon: "circle.lefthalf.filled",
                isUsed: game.hasUsedFiftyFifty
            ) {
                withAnimation {
                    game.useFiftyFifty()
                }
            }

            lifelineButton(
                title: "Tamaşaçılar",
                icon: "person.3.fill",
                isUsed: game.hasUsedAudienceHelp
            ) {
                withAnimation {
                    game.useAudienceHelp()
                }
            }

            lifelineButton(
                title: "Dosta zəng",
                icon: "phone.fill",
                isUsed: game.hasUsedPhoneFriend
            ) {
                withAnimation {
                    game.usePhoneFriend()
                }
            }
        }
    }

    private func lifelineButton(
        title: String,
        icon: String,
        isUsed: Bool,
        action: @escaping () -> Void
    ) -> some View {
        LifelineButtonView(
            title: title,
            icon: icon,
            isUsed: isUsed,
            isDisabled:
                game.selectedAnswerIndex != nil
                || game.isGameOver,
            action: action
        )
    }

    



    private var prizeLadderSheet: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 10) {
                    ForEach(
                        PrizeLadder.amounts.indices.reversed(),
                        id: \.self
                    ) { index in
                        HStack {
                            Text("\(index + 1)")

                            if index == 4 || index == 9 {
                                Image(systemName: "lock.fill")
                                    .accessibilityLabel(
                                        "Təminatlı hədd"
                                    )
                            }

                            Spacer()

                            Text(
                                PrizeFormatter.string(
                                    from: PrizeLadder.amounts[index]
                                )
                            )
                        }
                        .font(.headline)
                        .foregroundStyle(
                            index == game.currentQuestionIndex
                                ? Color.white
                                : AppTheme.secondaryText
                        )
                        .padding(16)
                        .background(
                            index == game.currentQuestionIndex
                                ? AppTheme.accent
                                : AppTheme.surface,
                            in: RoundedRectangle(cornerRadius: 14)
                        )
                    }
                }
                .padding(24)
            }
            .background(AppTheme.background)
            .navigationTitle("Mükafat pillələri")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Bağla") {
                        showsPrizeLadder = false
                    }
                }
            }
        }
        .preferredColorScheme(.dark)
    }

    // MARK: - Qələbə və nəticə

    private var resultTitle: String {
        if game.result?.isMillionWinner == true {
            return "Milyonçu oldun!"
        }

        if game.didWalkAway {
            return "Oyundan çəkildin"
        }

        if game.didCompleteAllQuestions {
            return "Bütün sualları tamamladın!"
        }

        return "Oyun bitdi"
    }
    
    private var resultShareText: String {
        if game.result?.isMillionWinner == true {
            return """
            👑 Zəka oyununda milyonçu oldum!

            15 sualın hamısını düzgün cavablandırdım.
            Virtual mükafat: 1 000 000 ₼
            """
        }

        return """
        🧠 Zəka oyunundakı nəticəm:

        Düzgün cavab sayı: \(game.correctAnswerCount)
        Virtual mükafat: \(PrizeFormatter.string(from: game.earnedPrize))
        """
    }

    

    private var resultCard: some View {
        VStack(spacing: 16) {
            if game.result?.isMillionWinner == true {
                MillionCelebrationView()
            } else {
                Image(systemName: "trophy.fill")
                    .font(.largeTitle)
                    .foregroundStyle(AppTheme.accent)

                Text(resultTitle)
                    .font(.title2.bold())
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.white)

                Text(
                    "Yekun mükafat: "
                    + PrizeFormatter.string(from: game.earnedPrize)
                )
                .font(.headline)
                .foregroundStyle(AppTheme.accent)
            }

            Text(
                "Düzgün cavab sayı: \(game.correctAnswerCount)"
            )
            .font(.subheadline)
            .foregroundStyle(AppTheme.secondaryText)

            if hasSavedResult {
                Label(
                    "Nəticə saxlanıldı",
                    systemImage: "checkmark.circle"
                )
                .font(.caption)
                .foregroundStyle(.green)
            }

            if let savingError {
                Text(savingError)
                    .font(.caption)
                    .foregroundStyle(.orange)

                Button("Yenidən sına") {
                    saveResult()
                }
                .foregroundStyle(AppTheme.accent)
            }
            
            ShareLink(item: resultShareText) {
                Label(
                    "Nəticəni paylaş",
                    systemImage: "square.and.arrow.up"
                )
                .font(.headline)
                .foregroundStyle(AppTheme.accent)
                .frame(maxWidth: .infinity)
                .padding(18)
                .background(
                    AppTheme.accent.opacity(0.12),
                    in: RoundedRectangle(cornerRadius: 16)
                )
            }
            .buttonStyle(.plain)

            Button {
                startNewGame()
            } label: {
                Label(
                    "Yenidən oyna",
                    systemImage: "arrow.clockwise"
                )
                .font(.headline)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(18)
                .background(
                    AppTheme.accent,
                    in: RoundedRectangle(cornerRadius: 16)
                )
            }
            .buttonStyle(.plain)
            .disabled(!hasSavedResult)
            .opacity(hasSavedResult ? 1 : 0.5)

            Button("Ana səhifəyə qayıt") {
                dismiss()
            }
            .font(.headline)
            .foregroundStyle(.white)
            .padding(.top, 8)
        }
        .frame(maxWidth: .infinity)
        .padding(24)
        .background(
            AppTheme.surface,
            in: RoundedRectangle(
                cornerRadius: AppTheme.cornerRadius
            )
        )
    }

    // MARK: - Yaddaş və yeni oyun

    private func saveResult() {
        guard !hasSavedResult,
              let result = game.result else {
            return
        }

        if result.modelContext == nil {
            modelContext.insert(result)
        }

        do {
            try modelContext.save()
            hasSavedResult = true
            savingError = nil
        } catch {
            savingError = "Nəticəni saxlamaq mümkün olmadı."
            print("Saxlama xətası: \(error)")
        }
    }

    private func startNewGame() {
        hasSavedResult = false
        savingError = nil
        showsWalkAwayConfirmation = false
        showsPrizeLadder = false
        game = GameViewModel()
    }

    private var loadingFailure: some View {
        VStack(spacing: 20) {
            Text(
                game.loadingError
                    ?? "Hazırda sual yoxdur."
            )
            .foregroundStyle(.white)
            .multilineTextAlignment(.center)

            Button("Ana səhifəyə qayıt") {
                dismiss()
            }
            .foregroundStyle(AppTheme.accent)
        }
    }
}

#Preview {
    NavigationStack {
        GameView()
    }
    .modelContainer(
        for: GameResult.self,
        inMemory: true
    )
}
