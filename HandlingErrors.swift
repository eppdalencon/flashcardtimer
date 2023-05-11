//
//  HandlingErrors.swift
//  FlashcardTimer
//
//  Created by Arthur Sobrosa on 09/05/23.
//
import SwiftUI

enum PossibleErrors: Error {
    case emptyText
}

func checkForEmptyTextError(_ text: String) throws {
    if text == "" {
        throw PossibleErrors.emptyText
    }
}

func checkForEmptyText(_ text: String) -> Bool {
    let text1 = text.trimmingCharacters(in: .whitespacesAndNewlines)

    do {
        try checkForEmptyTextError(text1)
        return false
    } catch {
        return true
    }
}

