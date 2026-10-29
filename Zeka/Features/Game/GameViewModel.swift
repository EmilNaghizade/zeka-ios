import Observation
import Foundation

@Observable
final class GameViewModel {
    let questions: [Question]

    private(set) var currentQuestionIndex = 0
    private(set) var selectedAnswerIndex: Int?
    private(set) var earnedPrize = 0
    private(set) var isGameOver = false
    private(set) var hasUsedFiftyFifty = false
    private(set) var hasUsedAudienceHelp = false
    private(set) var hasUsedPhoneFriend = false
    private(set) var hiddenAnswerIndices: Set<Int> = []
    private(set) var audiencePercentages: [Int] = []
    private(set) var friendSuggestedAnswerIndex: Int?
    private(set) var didWalkAway = false
    private(set) var loadingError: String?
    private(set) var correctAnswerCount = 0
    private(set) var result: GameResult?
    private(set) var pendingAnswerIndex: Int?

    init() {
        do {
            let loadedQuestions = try QuestionRepository.loadQuestions()
            print("Ümumi sual sayı: \(loadedQuestions.count)")

            for level in 1...3 {
                let count = loadedQuestions.filter {
                    $0.difficulty == level
                }.count

                print("Səviyyə \(level): \(count) sual")
            }
            let hasEnoughQuestions = (1...3).allSatisfy { level in
                loadedQuestions.filter {
                    $0.difficulty == level
                }.count >= 5
            }

            guard hasEnoughQuestions else {
                self.questions = []
                self.loadingError =
                    "Oyuna başlamaq üçün hər çətinlik səviyyəsində ən azı 5 sual olmalıdır."
                return
            }

            let easyQuestions = loadedQuestions
                .filter { $0.difficulty == 1 }
                .shuffled()
                .prefix(5)

            let mediumQuestions = loadedQuestions
                .filter { $0.difficulty == 2 }
                .shuffled()
                .prefix(5)

            let hardQuestions = loadedQuestions
                .filter { $0.difficulty == 3 }
                .shuffled()
                .prefix(5)

            let orderedQuestions =
                Array(easyQuestions)
                + Array(mediumQuestions)
                + Array(hardQuestions)

            self.questions = Array(
                orderedQuestions.prefix(PrizeLadder.amounts.count)
            ).map { question in
                question.shuffledAnswers()
            }
        }  catch {
            self.questions = []
            self.loadingError = "Sualları yükləmək mümkün olmadı."

            print("Sualların oxunma xətası: \(error.localizedDescription)")
        }
    }

    var currentQuestion: Question? {
        guard questions.indices.contains(currentQuestionIndex) else {
            return nil
        }

        return questions[currentQuestionIndex]
    }

    var currentPrize: Int {
        guard PrizeLadder.amounts.indices.contains(
            currentQuestionIndex
        ) else {
            return 0
        }

        return PrizeLadder.amounts[currentQuestionIndex]
    }

    var isAnswerCorrect: Bool {
        guard let question = currentQuestion,
              let selectedAnswerIndex else {
            return false
        }

        return question.isCorrect(
            answerIndex: selectedAnswerIndex
        )
    }
    
    

    var isLastQuestion: Bool {
        !questions.isEmpty
            && currentQuestionIndex == questions.count - 1
    }

    var didCompleteAllQuestions: Bool {
        isGameOver && isLastQuestion && isAnswerCorrect
    }

    func selectAnswer(at index: Int) {
        guard !isGameOver,
              selectedAnswerIndex == nil,
              let question = currentQuestion,
              question.answers.indices.contains(index) else {
            return
        }

        selectedAnswerIndex = index

        if question.isCorrect(answerIndex: index) {
            earnedPrize = currentPrize
            correctAnswerCount += 1
        }  else {
            earnedPrize = guaranteedPrize
            finishGame()
        }
    }
    
    func chooseAnswer(at index: Int) {
        guard !isGameOver,
              selectedAnswerIndex == nil,
              let question = currentQuestion,
              question.answers.indices.contains(index),
              !hiddenAnswerIndices.contains(index) else {
            return
        }

        pendingAnswerIndex = index
    }
    
    func confirmAnswer() {
        guard let index = pendingAnswerIndex else {
            return
        }

        selectAnswer(at: index)
        pendingAnswerIndex = nil
    }

    func nextQuestion() {
        guard !isGameOver, isAnswerCorrect else {
            return
        }

        if isLastQuestion {
            finishGame()
        } else {
            currentQuestionIndex += 1
            selectedAnswerIndex = nil
            pendingAnswerIndex = nil
            hiddenAnswerIndices = []
            audiencePercentages = []
            friendSuggestedAnswerIndex = nil
        }
    }
    func useFiftyFifty() {
        guard !hasUsedFiftyFifty,
              !isGameOver,
              selectedAnswerIndex == nil,
              let question = currentQuestion else {
            return
        }

        let wrongIndices = question.answers.indices.filter { index in
            index != question.correctAnswerIndex
        }

        hiddenAnswerIndices = Set(
            wrongIndices.shuffled().prefix(2)
        )
        
        if let pendingAnswerIndex,
           hiddenAnswerIndices.contains(pendingAnswerIndex) {
            self.pendingAnswerIndex = nil
        }

        hasUsedFiftyFifty = true
    }
    
    private func finishGame() {
        guard result == nil else {
            return
        }

        isGameOver = true

        result = GameResult(
            id: UUID(),
            playedAt: Date(),
            prize: earnedPrize,
            correctAnswerCount: correctAnswerCount,
            totalQuestionCount: questions.count,
            didWalkAway: didWalkAway
        )
    }
    
    func useAudienceHelp() {
        guard !hasUsedAudienceHelp,
              !isGameOver,
              selectedAnswerIndex == nil,
              let question = currentQuestion else {
            return
        }

        let visibleWrongIndices = question.answers.indices.filter { index in
            index != question.correctAnswerIndex
            && !hiddenAnswerIndices.contains(index)
        }

        var percentages = Array(
            repeating: 0,
            count: question.answers.count
        )

        let correctPercentage = Int.random(in: 55...75)
        percentages[question.correctAnswerIndex] = correctPercentage

        for _ in 0..<(100 - correctPercentage) {
            if let index = visibleWrongIndices.randomElement() {
                percentages[index] += 1
            } else {
                percentages[question.correctAnswerIndex] += 1
            }
        }

        audiencePercentages = percentages
        hasUsedAudienceHelp = true
    }
    
    func usePhoneFriend() {
        guard !hasUsedPhoneFriend,
              !isGameOver,
              selectedAnswerIndex == nil,
              let question = currentQuestion else {
            return
        }

        let visibleWrongIndices = question.answers.indices.filter { index in
            index != question.correctAnswerIndex
            && !hiddenAnswerIndices.contains(index)
        }

        let givesCorrectAnswer = Int.random(in: 1...100) <= 75

        if givesCorrectAnswer {
            friendSuggestedAnswerIndex = question.correctAnswerIndex
        } else {
            friendSuggestedAnswerIndex =
                visibleWrongIndices.randomElement()
                ?? question.correctAnswerIndex
        }

        hasUsedPhoneFriend = true
    }
    
    func walkAway() {
        guard !isGameOver,
              selectedAnswerIndex == nil else {
            return
        }

        didWalkAway = true
        finishGame()
    }

    private var guaranteedPrize: Int {
        // 10-cu sual artıq düzgün cavablandırılıbsa:
        if currentQuestionIndex >= 10 {
            return PrizeLadder.amounts[9]
        }

        // 5-ci sual artıq düzgün cavablandırılıbsa:
        if currentQuestionIndex >= 5 {
            return PrizeLadder.amounts[4]
        }

        return 0
    }
}
