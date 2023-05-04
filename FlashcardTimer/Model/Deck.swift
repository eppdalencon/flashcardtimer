//
//  Deck.swift
//  FlashcardTimer
//
//  Created by Leandro Silva on 03/05/23.
//

import Foundation
import SwiftUI

struct Deck: Hashable, Decodable {
    var deckId: Int
    var deckName: String
    var complete: Bool
    var numberPerTest: Int
    var flashcards: [Flashcard]
}

struct Flashcard: Hashable, Decodable {
    var flashcardId: Int
    var question: String
    var answer: String
}

