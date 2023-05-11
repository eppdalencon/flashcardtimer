//
//  ContentView.swift
//  FlashcardTimer
//
//  Created by Eduardo Dalencon on 02/05/23.
//
import SwiftUI

struct ContentView: View {
    @State private var showingPopup = false
    @State private var decksFromUserDefaults: [Deck] = []
    @State private var presentCreateDeckView = false

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                if decksFromUserDefaults != [] {
                    ForEach(decksFromUserDefaults, id: \.self) { deck in
                        NavigationLink(destination: DeckView(name: deck.deckName)) {
                            DeckListView(deck: deck)
                        }
                    }
                }
            }
            .navigationTitle("My decks")
            .navigationBarItems(trailing:
                Button {
                    presentCreateDeckView.toggle()
                } label: {
                    Image(systemName: "plus")
                }
            )
            .navigationBarTitleDisplayMode(.inline)
            .buttonStyle(PlainButtonStyle())
            .onAppear {
                decksFromUserDefaults = UserDefaultsService.getDecks()
                presentCreateDeckView = false
            }
            .navigationDestination(isPresented: $presentCreateDeckView) {
                CreateDeckView()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

