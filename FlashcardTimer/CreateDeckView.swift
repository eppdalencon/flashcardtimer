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
    @State private var numberPerTest: Int = 0
    
    @State private var newDeck: Deck? = nil
    @State private var showingAlert = false
    @State private var showingfTextAlert = false
    @State private var presentDeckView = false
    
    @Environment(\.dismiss) var dismiss
    
    var isEditing: Bool
    var deck: Deck
    
    init(isEditing: Bool, deck: Deck) {
        self.isEditing = isEditing
        self.deck = deck
    }
    
    init() {
        isEditing = false
        deck = LoadDecksFromJson().decks[0]
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Name of the deck", text: $name)
                        .onChange(of: name) { newvalue in
                            if name.count > 100 {
                                name = String(name.prefix(100))
                            }
                        }
                        .disableAutocorrection(true)
                        .focused($textIsFocused)
                    
                    Picker("Number per test", selection: $numberPerTest) {
                        ForEach(1 ..< 11) {
                            if $0 == 1 {
                                Text("\($0) flashcard")
                            } else {
                                Text("\($0) flashcards")
                            }
                        }
                    }
                }
            }
            .navigationTitle("Create a deck")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(trailing:
                Button("Send") {
                    if !checkForEmptyText(name) {
                        if !isEditing {
                            presentDeckView.toggle()
                            UserDefaultsService.createDeckByName(name: name, number: numberPerTest)
                            newDeck = UserDefaultsService.getDeckByName(deckName: name)
                        } else {
                            UserDefaultsService.modifyDeckName(deckId: deck.deckId, value: name)
                            UserDefaultsService.modifyDeckNumberPerTest(deckId: deck.deckId, value: numberPerTest + 1)
                            dismiss()
                        }

                    } else {
                        showingfTextAlert.toggle()
                    }
                    
                }
                .padding(.trailing)
                .alert(isPresented: $showingfTextAlert) {
                    Alert(title: Text("You haven't typed anything in!"), dismissButton: .default(Text("Try again")))
                }
            )
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

