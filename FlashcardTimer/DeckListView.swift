//
//  DeckListView.swift
//  FlashcardTimer
//
//  Created by Arthur Sobrosa on 08/05/23.
//
import SwiftUI

struct DeckListView: View {
    var deck: Deck
    var body: some View {
        Rectangle().fill(Color("Header").gradient)
            .frame(height: 100)
            .cornerRadius(12)
            .overlay(
                VStack(alignment: .leading, spacing: 17) {
                    Text(deck.deckName)
                        .font(.title2)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(Color("ButtonAction"))
                        .lineLimit(1)
                    
                    if deck.flashcards.count == 1 {
                        Text("\(deck.flashcards.count) card")
                            .font(.headline)
                            .foregroundColor(.white)
                    } else {
                        Text("\(deck.flashcards.count) cards")
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                }
                    .padding(.leading)
        )
    }
}

struct DeckListView_Previews: PreviewProvider {
    static var previews: some View {
        DeckListView(deck: LoadDecksFromJson().decks[0])
    }
}
