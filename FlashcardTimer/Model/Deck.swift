//
//  Deck.swift
//  FlashcardTimer
//
//  Created by Leandro Silva on 03/05/23.
//

import Foundation
import SwiftUI

struct Deck: Hashable, Codable{
    var deckId: Int
    var deckName: String
    var complete: Bool
    var numberPerTest: Int
    var flashcards: [Flashcard]
    
}
