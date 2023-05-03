//
//  FlashCard.swift
//  FlashcardTimer
//
import Foundation
import SwiftUI

struct Flashcard: Hashable, Codable{
    var flashcardId: Int
    var question: String
    var answer: String
}
