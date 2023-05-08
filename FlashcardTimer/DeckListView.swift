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
        ZStack(alignment: .leading) {
            Rectangle()
                .frame(width: 342, height: 68)
                .cornerRadius(8)
                .foregroundColor(Color("DeckColor"))
            
            VStack(alignment: .leading) {
                Text(deck.deckName)
                    .font(.title2)
                    
                Text("\(deck.numberPerTest) cards")
                    .font(.title3)
                    .foregroundColor(Color.gray)
            }
            .padding(.leading)
        }
    }
}

struct DeckListView_Previews: PreviewProvider {
    static var previews: some View {
        DeckListView(deck: ModelData().decks[0])
    }
}
