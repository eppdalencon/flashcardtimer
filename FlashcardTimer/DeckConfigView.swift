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
    @State private var optionsNotification: [Bool] = [false, false]
    let options = ["Vibrar", "Tocar"]
    
    var body: some View {
        NavigationStack {
            List {
                Toggle(isOn: $showNotification) {
                    Text("Notifications")
                        .bold()
                        .font(.title3)
                }
                
                if !showNotification {
                    Text("Activate your notifications by clicking the button above")
                        .font(.callout)
                    .foregroundColor(.gray)
                }
                
                if showNotification == true {
                    ForEach(0 ..< options.count) { index in
                        Toggle(isOn: $optionsNotification[index]) {
                            Text(options[index])
                        }
                    }
                }
            }
            .navigationTitle("Notifications Center")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct DeckConfigView_Previews: PreviewProvider {
    static var previews: some View {
        DeckConfigView(deck: LoadDecksFromJson().decks[0])
    }
}
