//
//  CreateFlashcardView.swift
//  FlashcardTimer
//
//  Created by Leandro Silva on 08/05/23.
//

import SwiftUI

enum ActiveAlert {
    case questionAlert, answerAlert, bothAlert
}

struct CreateFlashcardView: View {
    var deck: Deck
    var isEditing: Bool
    var flashcard: Flashcard?
    
    init(deck: Deck) {
        self.deck = deck
        isEditing = false
        flashcard = nil
    }
    
    init(deck: Deck, isEditing: Bool, flashcard: Flashcard?) {
        self.deck = deck
        self.isEditing = isEditing
        self.flashcard = flashcard
    }

    @State private var decksFromUserDefaults: [Deck] = UserDefaultsService.getDecks()
    
    @FocusState private var textIsFocused: Bool
    @State private var question: String = ""
    @State private var answer: String = ""
    @State private var flipped = false
    @State private var reveal = false
    @State private var showFlashmark = false
    @State private var showingAlert = false
    @State private var showingTextAlert = false
    @State private var activeAlert: ActiveAlert = .questionAlert
    @State private var hideTop = false
    
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            if !hideTop {
                ZStack {
                    Rectangle()
                        .ignoresSafeArea()
                        .foregroundColor(Color("Header"))
                        .frame(height: 40)
                    
                    HStack(spacing: 60) {
                        Button {
                            showingAlert.toggle()
                        } label: {
                            Text("Cancel")
                                .foregroundColor(Color("Background"))
                        }
                        .alert(isPresented: $showingAlert) {
                            Alert(title: Text("Are you sure you want to go back?"), message: nil, primaryButton: .destructive( Text("Yes"), action: {
                                    dismiss()
                                }),
                                secondaryButton: .cancel(Text("No"))
                            )
                        }
                        
                        Text(isEditing ? "Flashcard \(flashcard!.flashcardId)" : "Create a flashcard")
                            .foregroundColor(Color("Background"))
                            .padding(.trailing)
                            .bold()
                        
                        Button {
                            let q = checkForEmptyText(question)
                            let a = checkForEmptyText(answer)
                            
                            if !q && !a {
                                if isEditing {
                                    UserDefaultsService.modifyFlashcardQA(deckId: deck.deckId, flashcardId: flashcard!.flashcardId, question: question, answer: answer)
                                    
                                    decksFromUserDefaults = UserDefaultsService.getDecks()
                                    
                                    dismiss()
                                    showingTextAlert.toggle()
                                
                                } else {
                                    UserDefaultsService.addFlashcard(question: question, answer: answer, deckId: deck.deckId)
                                    
                                    decksFromUserDefaults = UserDefaultsService.getDecks()
                                    
                                    dismiss()
                                    showingTextAlert.toggle()
                                }
                            } else if q && !a {
                                activeAlert = .questionAlert
                            } else if !q && a {
                                activeAlert = .answerAlert
                            } else {
                                activeAlert = .bothAlert
                            }
                            
                            showingTextAlert.toggle()
                        } label: {
                            Text("Save")
                                .foregroundColor(Color("Background"))
                        }
                        .alert(isPresented: $showingTextAlert) {
                            switch activeAlert {
                            case .questionAlert:
                                return Alert(title: Text("You haven't typed in your question!"), dismissButton: .default(Text("Try again")))
                            case .answerAlert:
                                return Alert(title: Text("You haven't typed in your answer!"), dismissButton: .default(Text("Try again")))
                            case .bothAlert:
                                return Alert(title: Text("You haven't typed anything in!"), dismissButton: .default(Text("Try again")))
                            }
                        }
                    }
                    .padding(.bottom)
                }
            }
            
            ZStack {
                Rectangle()
                    .frame(width: 342, height: 430)
                    .cornerRadius(8)
                    .foregroundColor(Color("FlashcardColor"))
                    .shadow(color: .gray, radius: 4, x: 0, y: 4)
                    .onTapGesture {
                        if !hideTop {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                flipped.toggle()
                            }
                            reveal.toggle()
                        } else {
                            textIsFocused = false
                            hideTop = false
                        }
                    }
                    .overlay(
                        Text(reveal ? "Answer" : "Question")
                            .offset(y: -190)
                            .rotation3DEffect(.degrees(reveal ? 180 : 0), axis: (x: 0, y: 1, z: 0))
                    )
                    
                if !flipped {
                    TextField("Question", text: $question, axis: .vertical)
                        .onTapGesture {
                            hideTop = true
                        }
                        .onChange(of: question) { newvalue in
                            if question.count > 100 {
                                question = String(question.prefix(100))
                            }
                        }
                        .frame(width: 300)
                        .font(.title3)
                        .disableAutocorrection(true)
                        .focused($textIsFocused)
                        .rotation3DEffect(.degrees(flipped ? 180 : 0), axis: (x: 0, y: 1, z: 0))
                } else {
                    TextField("Answer", text: $answer, axis: .vertical)
                        .onTapGesture {
                            hideTop = true
                        }
                        .onChange(of: answer) { newvalue in
                            if answer.count > 100 {
                                answer = String(answer.prefix(100))
                            }
                        }
                        .frame(width: 300)
                        .font(.title3)
                        .disableAutocorrection(true)
                        .focused($textIsFocused)
                        .rotation3DEffect(.degrees(flipped ? 180 : 0), axis: (x: 0, y: 1, z: 0))
                }
            }
            .rotation3DEffect(.degrees(flipped ? -180 : 0), axis: (x: 0, y: 1, z: 0))
            
            Text("Tap card to flip")
                .padding(.top)
                .foregroundColor(.gray)
            
            Spacer()
        }
        .onTapGesture {
            textIsFocused = false
            hideTop = false
        }
    }
}

struct CreateFlashcardView_Previews: PreviewProvider {
    static var previews: some View {
        CreateFlashcardView(deck: LoadDecksFromJson().decks[0])
    }
}
