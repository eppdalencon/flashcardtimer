//
//  DeckView.swift
//  FlashcardTimer
//
//  Created by Arthur Sobrosa on 08/05/23.
//
import SwiftUI

struct DeckView: View {
    @State var deck: Deck
    
    @State var name: String
    
    @State private var flashcard: Flashcard? = nil

    @State private var flashcardsFromUserDefaults: [Flashcard] = []
    @State private var presentFlashcardView: Bool = false
    @State private var presentCreateFlashcardView: Bool = false
    @State private var presentCreateDeckView: Bool = false
    @State private var editButtonClicked: Bool = false
    @State private var editFlashcard: Bool = false
    @State private var showingAlert: Bool = false
    @State private var showingDeleteAlert: Bool = false
    @State private var clickedDoneButton: Bool = false

    @Environment(\.dismiss) var dismiss
    
    var gridItemLayout = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        NavigationStack {
            
            ScrollView {
                LazyVGrid(columns: gridItemLayout, spacing: 24) {
                    Button {
                        presentCreateFlashcardView.toggle()
                        editFlashcard = false
                    } label: {
                        ZStack {
                            Rectangle()
                                .frame(width: 98, height: 141)
                                .cornerRadius(4)
                                .foregroundColor(.white)
                                
                            VStack(alignment: .center) {
                                Image(systemName: "plus")
                                    .foregroundColor(.black)
                                
                                Text("Add card")
                                    .foregroundColor(.black)
                            }
                        }
                    }
                    
                    ForEach(flashcardsFromUserDefaults, id: \.self) { flashcard in
                        Button {
                            self.flashcard = flashcard
                            editFlashcard = true
                            presentCreateFlashcardView.toggle()
                            
                        } label: {
                            ZStack(alignment: .bottomTrailing) {
                                Rectangle()
                                    .frame(width: 98, height: 141)
                                    .cornerRadius(4)
                                    .foregroundColor(Color("FlashcardColor"))
                                    .shadow(color: .gray, radius: 4, x: 0, y: 4)
                                    .overlay(
                                        VStack(alignment: .trailing) {
                                            Text(flashcard.question)
                                                .foregroundColor(.black)
                                                .frame(width: 90)
                                                .font(.caption)
                                                .lineLimit(2)
                                        }
                                    )
                                
                                Text("\(flashcard.flashcardId)")
                                    .offset(x: -5, y: -5)
                                    .foregroundColor(.black)
                            }
                        }
                    }
                }
            }
            .padding(.top)

            VStack {
                HStack(spacing: 50) {
                    Button {
                        showingDeleteAlert.toggle()
                    } label: {
                        Text("Delete")
                            .frame(width: 100)
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(lineWidth: 1)
                            )
                    }
                    .alert(isPresented: $showingDeleteAlert) {
                        Alert(title: Text("Are you sure you want to delete this deck?"), message: nil, primaryButton: .destructive(Text("Delete"), action: {
                            UserDefaultsService.deleteDeck(deck.deckId)
                            
                            ReminderNotification.removeNotifications(deckId: deck.deckId) {
                            }
                            
                            dismiss()
                            
                            }),
                              secondaryButton: .cancel(Text("Cancel"))
                        )
                    }
                    
                    Button {
                        if flashcardsFromUserDefaults.count < deck.numberPerTest {
                            showingAlert.toggle()
                        } else {
                            presentFlashcardView.toggle()
                        }
                    } label: {
                        Text("Practice")
                            .frame(width: 100)
                            .foregroundColor(.white)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                            )
                    }
                    .alert(isPresented: $showingAlert) {
                        Alert(title: Text("You don't have enough cards to practice"), dismissButton: .default(Text("Try again")))
                    }
                }
                .foregroundColor(Color("ButtonAction"))

            }
            .navigationTitle(name)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing:
                Button {
                    presentCreateDeckView.toggle()
                } label: {
                    Text("Edit")
                }
            )
            .buttonStyle(PlainButtonStyle())
            .onAppear {
                flashcardsFromUserDefaults = UserDefaultsService.getFlashcards(deckId: deck.deckId)
                
                editFlashcard = false
            }
            .onChange(of: presentCreateFlashcardView) { _ in
                flashcardsFromUserDefaults = UserDefaultsService.getFlashcards(deckId: deck.deckId)
            }
            .sheet(isPresented: $presentFlashcardView) {
                FlashcardView(flashcards: Array(deck.flashcards.shuffled().prefix(deck.numberPerTest)), deck: deck)
            }
            .sheet(isPresented: $presentCreateFlashcardView) {
                if editFlashcard {
                    CreateFlashcardView(deck: deck, isEditing: true, flashcard: flashcard)
                } else {
                    CreateFlashcardView(deck: deck)
                }
            }
            .sheet(isPresented: $presentCreateDeckView, onDismiss: {
                if !clickedDoneButton {
                    name = deck.deckName
                }
            }) {
                CreateDeckView(isEditing: true, deck: deck, name: $name, clickedDoneButton: $clickedDoneButton)
            }
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(Color("Header"), for: .navigationBar)
        }
        .preferredColorScheme(.light)
    }
}

struct DeckView_Previews: PreviewProvider {
    static var previews: some View {
        DeckView(deck: LoadDecksFromJson().decks[1], name: LoadDecksFromJson().decks[1].deckName)
    }
}
