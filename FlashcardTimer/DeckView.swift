//
//  DeckView.swift
//  FlashcardTimer
//
//  Created by Arthur Sobrosa on 08/05/23.
//
import SwiftUI

struct DeckView: View {
    var deck: Deck
    
    @State private var decksFromUserDefaults: [Deck] = UserDefaultsService.getDecks()
    
    @Environment(\.dismiss) var dismiss
    
    var gridItemLayout = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: gridItemLayout, spacing: 24) {
                    ForEach(deck.flashcards.indices, id: \.self) { index in
                        ZStack(alignment: .bottomTrailing) {
                            Rectangle()
                                .frame(width: 98, height: 141)
                                .cornerRadius(4)
                                .foregroundColor(Color("DeckColor"))
                            
                            Text("\(deck.flashcards[index].flashcardId)")
                                .offset(x: -5, y: -5)
                        }
                    }
                    ZStack {
                        Rectangle()
                            .frame(width: 98, height: 141)
                            .foregroundColor(.white)
                        
                        NavigationLink(destination: CreateFlashcardView(deck: deck)) {
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60)
                        }
                    }
                    
                }
            }
            
            VStack {
                NavigationLink(destination: FlashcardView(flashcards: Array(deck.flashcards.shuffled().prefix(deck.numberPerTest)), deck: deck)) {
                    Rectangle()
                        .frame(width: 300, height: 70)
                        .cornerRadius(15)
                        .overlay(alignment: .center) {
                            Text("Play")
                                .foregroundColor(.black)
                                .font(.title)
                        }
                        .foregroundColor(.gray)
                }
            }
            .navigationTitle(deck.deckName)
            .navigationBarTitleDisplayMode(.inline)
            .buttonStyle(PlainButtonStyle())
            .navigationBarItems(trailing:
                NavigationLink {
                    DeckConfigView(deck: LoadDecksFromJson().decks[0])
                } label: {
                    Text("Edit deck")
                }
            )
        }
    }
}

struct DeckView_Previews: PreviewProvider {
    static var previews: some View {
        DeckView(deck: LoadDecksFromJson().decks[0])
    }
}

