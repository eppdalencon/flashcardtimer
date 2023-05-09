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
        NavigationStack {
            VStack {
                ForEach(LoadDecksFromJson().decks, id: \.self) { deck in
                    NavigationLink(destination: DeckView(deck: deck)) {
                        DeckListView(deck: deck)
                    }
                }
                
                Spacer()
            }
            .navigationTitle("My decks")
            .navigationBarItems(trailing:
                                            NavigationLink(destination: CreateDeckView()) {
                                                Image(systemName: "plus")
                                            }
                                        )
            .navigationBarTitleDisplayMode(.inline)
            .buttonStyle(PlainButtonStyle())
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

