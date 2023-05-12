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
    @State private var showingDeleteButton = false
    @State private var clickedDeleteButton = false

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                if decksFromUserDefaults != [] {
                    ForEach(decksFromUserDefaults, id: \.self) { deck in
                        HStack {
                            if showingDeleteButton {
                                Button {
                                    UserDefaultsService.deleteDeck(deck.deckId)
                                    clickedDeleteButton.toggle()
                                } label: {
                                    Image(systemName: "minus.circle.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 25)
                                    .foregroundColor(.red)
                                }
                            }
                            
                            NavigationLink(destination: DeckView(name: deck.deckName)) {
                                DeckListView(deck: deck)
                            }
                            
                            NavigationLink(destination: CreateDeckView(isEditing: true, deck: deck)) {
                                Image(systemName: "pencil")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20)
                            }
                            
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
                showingDeleteButton = false
            }
            .onChange(of: clickedDeleteButton) { _ in
                decksFromUserDefaults = UserDefaultsService.getDecks()
            }
            .navigationDestination(isPresented: $presentCreateDeckView) {
                CreateDeckView()
            }
            .navigationBarItems(leading:
                Button {
                showingDeleteButton.toggle()
                } label: {
                    Text(showingDeleteButton ? "Done" : "Edit")
                        .foregroundColor(.black)
                }
            )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

