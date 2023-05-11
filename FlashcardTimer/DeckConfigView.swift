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
    
    @State var vibrar: Notification = Notification(tipo: "Vibrar", isOn: true)
    @State var tocar: Notification = Notification(tipo: "Tocar", isOn: true)
    
    var body: some View {
        NavigationStack {
            List {
                Toggle(isOn: $showNotification) {
                    Text("Notifications")
                        .bold()
                        .font(.title3)
                }
                
                if showNotification == true {
                    Toggle(isOn: $vibrar.isOn) {
                        Text(vibrar.tipo)
                    }
                    
                    Toggle(isOn: $tocar.isOn) {
                        Text(tocar.tipo)
                    }
                    
                }else {
                    Text("Activate your notifications by clicking the button above")
                        .font(.callout)
                    .foregroundColor(.gray)
                    
                }
            }
            .navigationTitle("Notifications Center")
            .navigationBarTitleDisplayMode(.inline)
            .onChange(of: vibrar.isOn) { newValue in
                showNotification = newValue || tocar.isOn
            }
            .onChange(of: tocar.isOn) { newValue in
                showNotification = newValue || vibrar.isOn
            }
        }
    }
}

struct DeckConfigView_Previews: PreviewProvider {
    static var previews: some View {
        DeckConfigView(deck: LoadDecksFromJson().decks[0])
    }
}
