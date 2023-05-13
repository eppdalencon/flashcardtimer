//
//  DeckView.swift
//  FlashcardTimer
//
//  Created by Arthur Sobrosa on 08/05/23.
//
import SwiftUI

struct DeckView: View {
    var name: String
    @State private var flashcard: Flashcard? = nil

    @State private var flashcardsFromUserDefaults: [Flashcard] = []
    @State private var presentFlashcardView: Bool = false
    @State private var presentCreateFlashcardView: Bool = false
    @State private var editFlashcard: Bool = false
    @State private var showingAlert: Bool = false

    @Environment(\.dismiss) var dismiss

    var gridItemLayout = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        NavigationStack {
            let deck = UserDefaultsService.getDeckByName(deckName: name)
            
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
                                .foregroundColor(Color("DeckColor"))
                                .shadow(color: .gray, radius: 4, x: 7, y: 5)
                            
                            VStack(spacing: 16) {
                                Image(systemName: "plus")
                                
                                Text("Add card")
                            }
                        }
                    }
                    
                    ForEach(flashcardsFromUserDefaults, id: \.self) { flashcard in
                        Button {
                            presentCreateFlashcardView.toggle()
                            editFlashcard = true
                            self.flashcard = flashcard
                        } label: {
                            ZStack(alignment: .bottomTrailing) {
                                Rectangle()
                                    .frame(width: 98, height: 141)
                                    .cornerRadius(4)
                                    .foregroundColor(Color("DeckColor"))
                                    .shadow(color: .gray, radius: 4, x: 7, y: 5)
                                    .overlay(
                                        Text(flashcard.question)
                                            .frame(width: 90)
                                            .font(.caption)
                                            .lineLimit(2)
                                    )
                                
                                Text("\(flashcard.flashcardId)")
                                    .offset(x: -5, y: -5)
                            }
                        }
                    }
                }
            }
            .padding(.top)

            VStack {
                Button {
                    if flashcardsFromUserDefaults.count < deck!.numberPerTest {
                        showingAlert.toggle()
                    } else {
                        presentFlashcardView.toggle()
                    }
                } label: {
                    Rectangle()
                        .frame(width: 300, height: 70)
                        .cornerRadius(15)
                        .overlay(alignment: .center) {
                            Text("Play")
                                .foregroundColor(.black)
                                .font(.title)
                        }
                        .foregroundColor(.gray)
                }
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text("You don't have enough cards to play"), dismissButton: .default(Text("Try again")))
                }
            }
            .navigationTitle(name)
            .navigationBarTitleDisplayMode(.inline)
            .buttonStyle(PlainButtonStyle())
            .onAppear {
                flashcardsFromUserDefaults = UserDefaultsService.getFlashcards(deckId: deck!.deckId)
                editFlashcard = false
            }
            .onChange(of: presentCreateFlashcardView) { newValue in
                flashcardsFromUserDefaults = UserDefaultsService.getFlashcards(deckId: deck!.deckId)
            }
            .navigationDestination(isPresented: $presentFlashcardView) {
                FlashcardView(flashcards: Array(deck!.flashcards.shuffled().prefix(deck!.numberPerTest)), deck: deck!)
            }
            .fullScreenCover(isPresented: $presentCreateFlashcardView) {
                if editFlashcard {
                    CreateFlashcardView(deck: deck!, isEditing: true, flashcard: flashcard)
                } else {
                    CreateFlashcardView(deck: deck!)
                }
            }
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(Color("DeckColor"), for: .navigationBar)
        }
    }
}

//struct DeckView_Previews: PreviewProvider {
//    static var previews: some View {
//        DeckView(name: LoadDecksFromJson().decks[0].deckName)
//    }
//}
