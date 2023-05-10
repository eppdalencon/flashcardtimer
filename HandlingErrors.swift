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

func checkForEmptyText(_ text: String) throws {
    if text == "" {
        throw PossibleErrors.emptyText
    }
}

func check(_ text: String) -> Bool {
    do {
        try checkForEmptyText(text)
        return true
    } catch {
        return false
    }
}
