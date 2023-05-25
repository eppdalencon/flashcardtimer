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
    @State private var name = ""
    let index = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18]
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                if decksFromUserDefaults != [] {
                    ForEach(decksFromUserDefaults, id: \.self) { deck in
                        NavigationLink(destination: DeckView(deck: deck, name: deck.deckName)) {
                            DeckListView(deck: deck)
                        }
                        .padding([.top, .leading, .trailing])
                    }
                } else {
                    ForEach(index, id:\.self) { _ in
                        Spacer()
                    }
                    
                    VStack {
                        Image("Cards")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200)
                        
                        Text("It looks like you haven't added any deck of flashcards yet! Try clicking on the plus button above.")
                            .foregroundColor(.gray)
                            .frame(width: 320)
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
                decksFromUserDefaults = UserDefaultsService.getDecks()
                presentCreateDeckView = false
                name = ""
                
            }
            .navigationDestination(isPresented: $presentCreateDeckView) {
                CreateDeckView(name: $name, clickedDoneButton: .constant(false))
            }
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(Color("Header"), for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            
        }
        .preferredColorScheme(.light)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

