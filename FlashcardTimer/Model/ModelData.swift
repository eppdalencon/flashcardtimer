//
//  ModelData.swift
//  FlashcardTimer
//
//  Created by Leandro Silva on 03/05/23.
//

import Foundation
import Combine

final class ModelData: ObservableObject {
    @Published var decks: [Deck] = loadData()
}

func loadData() -> [Deck] {
    guard let jsonUrl = Bundle.main.url(forResource: "deckData", withExtension: "json") else {
        fatalError("Cannot find deckData.json file")
    }
    
    guard let jsonData = try? Data(contentsOf: jsonUrl) else {
        fatalError("Cannot find deckData.json file")
    }
    
    let decoder = JSONDecoder()
    
    do {
        let decks = try decoder.decode([Deck].self, from: jsonData)
        return decks
    } catch {
        print("Error decoding JSON: \(error)")
    }
    return []
}
