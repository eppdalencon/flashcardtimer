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
    @State private var presentDeckConfigView: Bool = false
    @State private var editFlashcard: Bool = false
    @State private var showingAlert: Bool = false
    @State private var clickedDeleteButton: Bool = false
    @State private var showingEditButtons: Bool = false
    @State private var flipped = false

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
                        ZStack(alignment: flipped ? .bottomLeading : .bottomTrailing) {
                            if !flipped {
                                Rectangle()
                                    .frame(width: 98, height: 141)
                                    .cornerRadius(4)
                                    .foregroundColor(Color("FlashcardColor"))
                                    .shadow(color: .gray, radius: 4, x: 0, y: 4)
                                    .overlay(
                                        VStack(alignment: .leading) {
                                            Text(flashcard.question)
                                                .frame(width: 90)
                                                .font(.caption)
                                                .lineLimit(2)
                                                .rotation3DEffect(.degrees(flipped ? 180 : 0), axis: (x: 0, y: 1, z: 0))

                                        
                                        }
                                    )
                            } else {
                                Rectangle()
                                    .frame(width: 98, height: 141)
                                    .cornerRadius(4)
                                    .foregroundColor(Color("FlashcardColor"))
                                    .shadow(color: .gray, radius: 4, x: 0, y: 4)
                                    .overlay(
                                        VStack(alignment: .trailing) {
                                            Text(flashcard.answer)
                                                .frame(width: 90)
                                                .font(.caption)
                                                .lineLimit(2)
                                                .rotation3DEffect(.degrees(flipped ? 180 : 0), axis: (x: 0, y: 1, z: 0))

                                        
                                        }
                                    )
                            }

                            if !showingEditButtons {
                                if !flipped {
                                    Text("\(flashcard.flashcardId)")
                                        .offset(x: -5, y: -5)
                                } else {
                                    Text("\(flashcard.flashcardId)")
                                        .offset(x: -5, y: -5)
                                        .rotation3DEffect(.degrees(flipped ? 180 : 0), axis: (x: 0, y: 1, z: 0))
                                }
                            } else {
                                if !flipped {
                                    Text("\(flashcard.flashcardId)")
                                        .offset(x: -5, y: -5)

                                    Button {
                                        self.flashcard = flashcard
                                        editFlashcard.toggle()
                                        presentCreateFlashcardView.toggle()
                                    } label: {
                                        Image(systemName: "pencil")
                                            .foregroundColor(.black)
                                    }
                                    .offset(x: -5, y: -120)

                                    Button {
                                        UserDefaultsService.deleteFlashcard(flashcardId: flashcard.flashcardId, deckId: deck!.deckId)
                                        clickedDeleteButton.toggle()
                                    } label: {
                                        Image(systemName: "xmark")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 10)
                                            .foregroundColor(.red)
                                    }
                                    .offset(x: -80, y: -122)
                                } else {
                                    Text("\(flashcard.flashcardId)")
                                        .offset(x: -5, y: -5)
                                        .rotation3DEffect(.degrees(flipped ? 180 : 0), axis: (x: 0, y: 1, z: 0))

                                    Button {
                                        self.flashcard = flashcard
                                        editFlashcard.toggle()
                                        presentCreateFlashcardView.toggle()
                                    } label: {
                                        Image(systemName: "pencil")
                                            .foregroundColor(.black)
                                    }
                                    .offset(x: 3, y: -120)

                                    Button {
                                        UserDefaultsService.deleteFlashcard(flashcardId: flashcard.flashcardId, deckId: deck!.deckId)
                                        clickedDeleteButton.toggle()
                                    } label: {
                                        Image(systemName: "xmark")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 10)
                                            .foregroundColor(.red)
                                    }
                                    .offset(x: 80, y: -122)
                                }
                            }
                        }
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                flipped.toggle()
                            }
                        }
                        .rotation3DEffect(.degrees(flipped ? -180 : 0), axis: (x: 0, y: 1, z: 0))
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
                                .foregroundColor(Color("Background"))
                                .font(.title)
                        }
                        .foregroundColor(Color("ButtonAction"))
                }
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text("You don't have enough cards to play"), dismissButton: .default(Text("Try again")))
                }
            }
            .navigationTitle(name)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing:
                HStack {
                    Button {
                        presentDeckConfigView.toggle()
                    } label: {
                        Image(systemName: "bell.fill")
                            .foregroundColor(Color("Background"))
                    }

                    Button {
                        showingEditButtons.toggle()
                         if(editFlashcard == true){
                           editFlashcard.toggle()
                         }
                    } label: {
                        Text(showingEditButtons ? "Done" : "Edit")
                            .foregroundColor(Color("Background"))
                    }
                }
                
            )
            .buttonStyle(PlainButtonStyle())
            .onAppear {
                flashcardsFromUserDefaults = UserDefaultsService.getFlashcards(deckId: deck!.deckId)
                editFlashcard = false
                showingEditButtons = false
                flipped = false
            }
            .onChange(of: presentCreateFlashcardView) { newValue in
                flashcardsFromUserDefaults = UserDefaultsService.getFlashcards(deckId: deck!.deckId)
                showingEditButtons = false
                flipped = false
            }
            .onChange(of: clickedDeleteButton) { newValue in
                flashcardsFromUserDefaults = UserDefaultsService.getFlashcards(deckId: deck!.deckId)
            }
            .fullScreenCover(isPresented: $presentFlashcardView) {
                FlashcardView(flashcards: Array(deck!.flashcards.shuffled().prefix(deck!.numberPerTest)), deck: deck!)
            }
            .fullScreenCover(isPresented: $presentCreateFlashcardView) {
                if editFlashcard {
                    CreateFlashcardView(deck: deck!, isEditing: true, flashcard: flashcard)
                } else {
                    CreateFlashcardView(deck: deck!)
                }
            }
            .fullScreenCover(isPresented: $presentDeckConfigView) {
                DeckConfigView(deck: deck!)
            }
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(Color("Header"), for: .navigationBar)
        }
        .preferredColorScheme(.light)
    }
}

struct DeckView_Previews: PreviewProvider {
    static var previews: some View {
        DeckView(name: LoadDecksFromJson().decks[0].deckName)
    }
}
