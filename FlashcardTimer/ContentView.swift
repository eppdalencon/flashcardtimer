//
//  ContentView.swift
//  FlashcardTimer
//
//  Created by Eduardo Dalencon on 02/05/23.
//

import SwiftUI

struct ContentView: View {
    @State private var showingPopup = false

    @State private var decksFromUserDefaults: [Deck] = UserDefaultsService.getDecks()
    
    var body: some View {
        
            List(decksFromUserDefaults, id: \.deckId) { deck in
                Text("\(deck.deckName)")
            }
        
        
        List(UserDefaultsService.getFlashcards(deckId: 1), id: \.flashcardId) { deck in
                Text("\(deck.question)")
            }
            
            
                Button("Add Deck") {
                showingPopup = true
                    
                    UserDefaultsService.createDeckByName(name:"Novo deck")
                decksFromUserDefaults = UserDefaultsService.getDecks()
                
                
                }
            
            Button("Add flashcard") {
                UserDefaultsService.addFlashcard(question: "qual o nome do eduardo", answer: "eduardo", deckId: 1)
                decksFromUserDefaults = UserDefaultsService.getDecks()
                print(decksFromUserDefaults)
                
            }
        
        Button("Delete Deck") {
            UserDefaultsService.deleteDeck(1)
            decksFromUserDefaults = UserDefaultsService.getDecks()
            print(decksFromUserDefaults)
            
        }
        
        Button("Delete Flashcard") {
            UserDefaultsService.deleteFlashcard(flashcardId: 2, deckId: 1)
            decksFromUserDefaults = UserDefaultsService.getDecks()
            print(decksFromUserDefaults)
            
        }
        
        Button("Change Name") {
            UserDefaultsService.modifyDeckName(deckId: 1, value: "Teste")
            decksFromUserDefaults = UserDefaultsService.getDecks()
            print(decksFromUserDefaults)
            
        }
                
            
        }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
