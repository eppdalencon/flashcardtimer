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

    @State private var decksFromUserDefaults: [Deck] = UserDefaultsService.getDecks()
    
    @FocusState private var textIsFocused: Bool
    @State private var question: String = ""
    @State private var answer: String = ""
    @State private var flipped = false
    @State private var changeColor = true
    @State private var reveal = false
    @State private var showFlashmark = false
    @State private var showingAlert = false
    @State private var showingTextAlert = false
    @State private var activeAlert: ActiveAlert = .questionAlert
    
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            ZStack {
                Rectangle()
                    .frame(width: 342, height: 430)
                    .cornerRadius(8)
                    .foregroundColor(changeColor ? Color("FlashcardQuestionColor") : Color("FlashcardAnswerColor"))
                if !flipped {
                    TextField("Question", text: $question, axis: .vertical)
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
            
            Button {
                withAnimation(.easeInOut(duration: 0.5)) {
                    flipped.toggle()
                }
                changeColor.toggle()
                reveal.toggle()
            } label: {
                Text(reveal ? "Go to question" : "Go to answer")
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
            }
            .padding(.top)
            
            Button("Save") {
                UserDefaultsService.addFlashcard(question: question, answer: answer, deckId: deck.deckId)
                decksFromUserDefaults = UserDefaultsService.getDecks()
                
                let q = checkForEmptyText(question)
                let a = checkForEmptyText(answer)
                
                if !q && !a {
                    dismiss()
                    showingTextAlert.toggle()
                } else if q && !a {
                    activeAlert = .questionAlert
                } else if !q && a {
                    activeAlert = .answerAlert
                } else {
                    activeAlert = .bothAlert
                }
                
                showingTextAlert.toggle()
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
        }
        .navigationTitle("Create a flashcard")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading:
            Button {
                showingAlert.toggle()
            } label: {
                Image(systemName: "arrow.left")
                Text("Back")
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
    }
}

struct CreateFlashcardView_Previews: PreviewProvider {
    static var previews: some View {
        CreateFlashcardView(deck: LoadDecksFromJson().decks[0])
    }
}
