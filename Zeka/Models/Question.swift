//
//  Question.swift
//  Zeka
//
//  Created by admin on 29.10.26.
//

import Foundation

struct Question: Identifiable,Codable {
    let id: String
    let category: String
    let difficulty: Int
    let text: String
    let answers: [String]
    let correctAnswerIndex: Int
    let explanation: String
    var isValid: Bool {
        let cleanAnswers = answers.map {
            $0.trimmingCharacters(in: .whitespacesAndNewlines)
        }

        return !id.trimmingCharacters(
            in: .whitespacesAndNewlines
        ).isEmpty
            && !text.trimmingCharacters(
                in: .whitespacesAndNewlines
            ).isEmpty
            && (1...3).contains(difficulty)
            && answers.count == 4
            && cleanAnswers.allSatisfy { !$0.isEmpty }
            && Set(cleanAnswers).count == 4
            && answers.indices.contains(correctAnswerIndex)
    }
    var difficultyTitle: String {
        switch difficulty {
        case 1:
            return "Asan"
        case 2:
            return "Orta"
        case 3:
            return "Çətin"
        default:
            return "Naməlum"
        }
    }

    func isCorrect(answerIndex: Int) -> Bool {
        answerIndex == correctAnswerIndex
    }
    
    func shuffledAnswers() -> Question {
        let shuffledIndices = answers.indices.shuffled()

        let newAnswers = shuffledIndices.map { originalIndex in
            answers[originalIndex]
        }

        guard let newCorrectIndex = shuffledIndices.firstIndex(
            of: correctAnswerIndex
        ) else {
            return self
        }

        return Question(
            id: id,
            category: category,
            difficulty: difficulty,
            text: text,
            answers: newAnswers,
            correctAnswerIndex: newCorrectIndex,
            explanation: explanation
        )
    }
}
