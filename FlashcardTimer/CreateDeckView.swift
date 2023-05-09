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
    @State private var showingAlert = false
    @State var isSent = false
    @State var isAlerted = false
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
                    .fullScreenCover(isPresented: $isAlerted) {
                        ContentView()
                    }
                    .navigationTitle("Create a deck")
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationBarBackButtonHidden(true)
                                    .navigationBarItems(leading:
                                        Button(action: {
                                            self.showingAlert = true
                                        }) {
                                            Image(systemName: "arrow.left")
                                            Text("Back")
                                        }
                                        .alert(isPresented: $showingAlert) {
                                            Alert(title: Text("Are you sure you want to go back?"), message: nil, primaryButton: .destructive(Text("Yes"), action: {
                                                isAlerted.toggle()
                                            }), secondaryButton: .cancel(Text("No")))
                                        }
                                    )
            }
        }
        
            
    }
}

struct CreateDeckView_Previews: PreviewProvider {
    static var previews: some View {
        CreateDeckView()
    }
}
