//
//  CreateDeckView.swift
//  FlashcardTimer
//
//  Created by Eduardo Dalencon on 09/05/23.
//

import SwiftUI

struct CreateDeckView: View {
    @State private var name: String = ""
    @State private var newDeck: Deck? = nil
    @State var isSent = false
    var body: some View {
        NavigationStack {
            VStack{
                TextField("Name of the deck", text: $name)
                    .onChange(of: name) { newvalue in
                        if name.count > 100 {
                            name = String(name.prefix(100))
                        }
                    }
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .disableAutocorrection(true)
                
                
                Button("Send") {
                    
                    UserDefaultsService.createDeckByName(name: name)
                    newDeck = UserDefaultsService.getDeckByName(deckName: name)
                    isSent.toggle()
                    
                }
                .padding()
                .font(.title2)
                .foregroundColor(.black)
                .frame(maxWidth: 340)
                .background(
                    RoundedRectangle(
                        cornerRadius: 15
                    )
                    .fill(Color("FlashcardQuestionColor"))
                )
                
                Spacer()
                    .fullScreenCover(isPresented: $isSent) {
                        DeckView(deck: UserDefaultsService.getDeckByName(deckName: name)!, number: 1)
                    }
                    .navigationTitle("Create a deck")
                    .navigationBarTitleDisplayMode(.inline)
            }
        }
        
            
    }
}

struct CreateDeckView_Previews: PreviewProvider {
    static var previews: some View {
        CreateDeckView()
    }
}
