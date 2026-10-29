import Foundation
import SwiftData

@Model
final class GameResult {
    @Attribute(.unique) var id: UUID

    var playedAt: Date
    var prize: Int
    var correctAnswerCount: Int
    var totalQuestionCount: Int
    var didWalkAway: Bool

    init(
        id: UUID,
        playedAt: Date,
        prize: Int,
        correctAnswerCount: Int,
        totalQuestionCount: Int,
        didWalkAway: Bool
    ) {
        self.id = id
        self.playedAt = playedAt
        self.prize = prize
        self.correctAnswerCount = correctAnswerCount
        self.totalQuestionCount = totalQuestionCount
        self.didWalkAway = didWalkAway
    }

   
    var outcomeTitle: String {
        if isMillionWinner {
            return "Milyonçu oldun!"
        }
        if didWalkAway {
            return "Oyundan çəkildin"
        }

        if totalQuestionCount > 0
            && correctAnswerCount == totalQuestionCount {
            return "Bütün sualları keçdin"
        }

        return "Səhv cavabla bitdi"
    }
    
    var isMillionWinner: Bool {
        !didWalkAway
            && totalQuestionCount == 15
            && correctAnswerCount == 15
            && prize == 1_000_000
    }
}
