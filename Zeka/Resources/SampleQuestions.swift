//
//  SampleQuestions.swift
//  Zeka
//
//  Created by admin on 29.10.26.
//

import Foundation

enum SampleQuestions {
    static let all: [Question] = [
        Question(
            id: "geo_001",
            category: "Coğrafiya",
            difficulty: 1,
            text: "Azərbaycanın paytaxtı hansı şəhərdir?",
            answers: [
                "Gəncə",
                "Bakı",
                "Şəki",
                "Lənkəran"
            ],
            correctAnswerIndex: 1,
            explanation: "Azərbaycanın paytaxtı Bakı şəhəridir."
        ),

        Question(
            id: "science_001",
            category: "Elm",
            difficulty: 1,
            text: "Suyun kimyəvi formulu hansıdır?",
            answers: [
                "CO₂",
                "O₂",
                "H₂O",
                "NaCl"
            ],
            correctAnswerIndex: 2,
            explanation: """
            Su molekulu iki hidrogen və bir oksigen \
            atomundan ibarətdir.
            """
        ),

        Question(
            id: "tech_001",
            category: "Texnologiya",
            difficulty: 1,
            text: "CPU-nun əsas vəzifəsi nədir?",
            answers: [
                "Şəkilləri çap etmək",
                "İnternet bağlantısı yaratmaq",
                "Ekranın parlaqlığını artırmaq",
                "Proqram təlimatlarını icra etmək"
            ],
            correctAnswerIndex: 3,
            explanation: """
            CPU proqram təlimatlarını icra edən \
            mərkəzi prosessordur.
            """
        )
    ]
}
