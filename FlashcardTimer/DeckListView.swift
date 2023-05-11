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
        Rectangle()
            .frame(width: 342, height: 60)
            .cornerRadius(8)
            .foregroundColor(Color("DeckColor"))
            .overlay(
                VStack(alignment: .leading) {
                    Text(deck.deckName)
                        .font(.title2)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .lineLimit(1)
                    
                    Text("\(deck.numberPerTest) cards")
                        .font(.title3)
                        .foregroundColor(.gray)
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
