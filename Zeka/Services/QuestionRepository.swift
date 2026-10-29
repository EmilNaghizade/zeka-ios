//
//  QuestionRepository.swift
//  Zeka
//
//  Created by admin on 29.10.26.
//

import Foundation

enum QuestionLoadingError: LocalizedError {
    case fileNotFound
    case invalidQuestion(id: String)
    case duplicateID(id: String)

    var errorDescription: String? {
        switch self {
        case .fileNotFound:
            return "Sual faylı tapılmadı."

        case .invalidQuestion(let id):
            return "Sualın məlumatları düzgün deyil. ID: \(id)"

        case .duplicateID(let id):
            return "Təkrarlanan sual ID-si: \(id)"
        }
    }
}

enum QuestionRepository {
    static func loadQuestions() throws -> [Question] {
        guard let url = Bundle.main.url(
            forResource: "questions_az",
            withExtension: "json"
        ) else {
            throw QuestionLoadingError.fileNotFound
        }

        let data = try Data(contentsOf: url)

        let questions = try JSONDecoder().decode(
            [Question].self,
            from: data
        )

        var seenIDs: Set<String> = []

        for question in questions {
            guard question.isValid else {
                throw QuestionLoadingError.invalidQuestion(
                    id: question.id
                )
            }

            guard seenIDs.insert(question.id).inserted else {
                throw QuestionLoadingError.duplicateID(
                    id: question.id
                )
            }
        }

        return questions
    }
}
