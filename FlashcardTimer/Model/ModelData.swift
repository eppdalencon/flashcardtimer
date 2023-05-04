//
//  ModelData.swift
//  FlashcardTimer
//
//  Created by Leandro Silva on 03/05/23.
//

import Foundation
import Combine

final class ModelData: ObservableObject {
    @Published var decks: [Deck] = loadDeck()
}

func loadDeck() -> [Deck] {
    let deck1 = Deck(
        deckId: 1,
        deckName: "Geografia",
        complete: false,
        numberPerTest: 3,
        flashcards: [
            Flashcard(
                flashcardId: 1,
                question: "Quantos estados tem o Brasil?",
                answer: "26"
            ),
            Flashcard(
                flashcardId: 2,
                question: "Qual a capital de São paulo?",
                answer: "São Paulo"
            ),
            Flashcard(
                flashcardId: 3,
                question: "Qual a capital do Rio de Janeiro?",
                answer: "Rio de Janeiro"
            )
        ]
    )

    let deck2 = Deck(
        deckId: 2,
        deckName: "História",
        complete: false,
        numberPerTest: 5,
        flashcards: [
            Flashcard(
                flashcardId: 10,
                question: "Quem descobriu o Brasil?",
                answer: "Pedro Alvares Cabral"
            ),
            Flashcard(
                flashcardId: 11,
                question: "Quem proclamou a independencia do BrasiL?",
                answer: "Dom Pedro I"
            )
        ]
    )

    let deck3 = Deck(
        deckId: 3,
        deckName: "Biologia",
        complete: false,
        numberPerTest: 4,
        flashcards: [
            Flashcard(
                flashcardId: 20,
                question: "Qual o maior mamífero existente?",
                answer: "Baleia"
            )
        ]
    )

    let decks = [deck1, deck2, deck3]
    return decks
}
