//
//  DeckConfigView.swift
//  FlashcardTimer
//
//  Created by Leandro Silva on 10/05/23.
//

import SwiftUI

struct DeckConfigView: View {
    var deck: Deck
    @State private var showNotification = false
    
    var body: some View {
        List{
            Toggle(isOn: $showNotification) {
                Text("Notification")
                    .bold()
            }
        }
        .navigationTitle("Deck config")
    }
    
}

struct DeckConfigView_Previews: PreviewProvider {
    static var previews: some View {
        DeckConfigView(deck: LoadDecksFromJson().decks[0])
    }
}
