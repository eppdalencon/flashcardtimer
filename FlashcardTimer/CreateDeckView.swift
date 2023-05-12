//
//  CreateDeckView.swift
//  FlashcardTimer
//
//  Created by Eduardo Dalencon on 09/05/23.
//
import SwiftUI

struct CreateDeckView: View {
    @FocusState private var textIsFocused: Bool
    @State private var name: String = ""
    @State private var newDeck: Deck? = nil
    @State private var showingAlert = false
    @State private var showingfTextAlert = false
    @State private var presentDeckView = false
    
    @Environment(\.dismiss) var dismiss
    
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
                    .focused($textIsFocused)
                
                
                Button("Send") {
                    if !checkForEmptyText(name) {
                        presentDeckView.toggle()
                        UserDefaultsService.createDeckByName(name: name)
                        newDeck = UserDefaultsService.getDeckByName(deckName: name)
                    } else {
                        showingfTextAlert.toggle()
                    }
                    
                }
                .alert(isPresented: $showingfTextAlert) {
                    Alert(title: Text("You haven't typed anything in!"), dismissButton: .default(Text("Try again")))
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

                .navigationTitle("Create a deck")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarBackButtonHidden(true)
                .navigationBarItems(leading:
                    Button {
                        showingAlert.toggle()
                    } label: {
                        Image(systemName: "chevron.left")
                        Text("My decks")
                    }
                    .alert(isPresented: $showingAlert) {
                        Alert(title: Text("Are you sure you want to go back?"), message: nil, primaryButton: .destructive( Text("Yes"), action: {
                                dismiss()
                            }),
                            secondaryButton: .cancel(Text("No"))
                        )
                    }
                )
            }
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    
                    Button("Done") {
                        textIsFocused = false
                    }
                }
            }
            .navigationDestination(isPresented: $presentDeckView) {
                DeckView(name: name)
            }
        }
    }
}

struct CreateDeckView_Previews: PreviewProvider {
    static var previews: some View {
        CreateDeckView()
    }
}

