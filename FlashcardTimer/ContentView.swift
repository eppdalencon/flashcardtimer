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
    @State private var showingEditButtons = false
    @State private var clickedDeleteButton = false

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                if decksFromUserDefaults != [] {
                    ForEach(decksFromUserDefaults, id: \.self) { deck in
                        HStack {
                            if showingEditButtons {
                                Button {
                                    if decksFromUserDefaults.count > 3 {
                                        UserDefaultsService.deleteDeck(deck.deckId)
                                    }
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
                            .padding(.top)
                            
                            if showingEditButtons {
                                NavigationLink(destination: CreateDeckView(isEditing: true, deck: deck)) {
                                    Image(systemName: "pencil")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 20)
                                }
                            }
                        }
                        .padding(.trailing)
                    }
                }
            }
            .navigationTitle("My decks")
            .navigationBarItems(trailing:
                Button {
                    presentCreateDeckView.toggle()
                } label: {
                    Image(systemName: "plus")
                        .foregroundColor((Color("Background")))
                }
            )
            .navigationBarTitleDisplayMode(.inline)
            .buttonStyle(PlainButtonStyle())
            .onAppear {
//                for deck in UserDefaultsService.getDecks() {
//                    UserDefaultsService.deleteDeck(deck.deckId)
//                }
                decksFromUserDefaults = UserDefaultsService.getDecks()
                presentCreateDeckView = false
                showingEditButtons = false
            }
            .onChange(of: clickedDeleteButton) { _ in
                decksFromUserDefaults = UserDefaultsService.getDecks()
            }
            .navigationDestination(isPresented: $presentCreateDeckView) {
                CreateDeckView()
            }
            .navigationBarItems(leading:
                Button {
                showingEditButtons.toggle()
                } label: {
                    Text(showingEditButtons ? "Done" : "Edit")
                        .foregroundColor(Color("Background"))
                }
            )
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(Color("Header"), for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

