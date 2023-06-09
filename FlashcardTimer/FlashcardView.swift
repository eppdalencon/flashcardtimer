//
//  FlashcardView.swift
//  FlashcardTimer
//
//  Created by Arthur Sobrosa on 08/05/23.
//
import SwiftUI

struct FlashcardView: View {
    var flashcards: [Flashcard]
    var deck: Deck
    
    @State var currentIndex = 0

    @State private var flipped = false
    @State private var changeColor = true
    @State private var reveal = false
    @State private var showFlashmark = false
    @State private var showingAlert = false

    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            TabView(selection: $currentIndex) {
                ForEach(flashcards.indices, id: \.self) { index in
                    VStack {
                        ZStack {
                            Rectangle()
                                .frame(width: 342, height: 430)
                                .cornerRadius(8)
                                .foregroundColor(changeColor ? Color("FlashcardQuestionColor") : Color("FlashcardAnswerColor"))
                                .shadow(color: .gray, radius: 4, x: 10, y: 13)

                            if !flipped {
                                Text(flashcards[index].question)
                                    .frame(width: 340)
                                    .font(.title3)
                                    .rotation3DEffect(.degrees(flipped ? 180 : 0), axis: (x: 0, y: 1, z: 0))
                            } else {
                                Text(flashcards[index].answer)
                                    .frame(width: 340)
                                    .font(.title3)
                                    .rotation3DEffect(.degrees(flipped ? 180 : 0), axis: (x: 0, y: 1, z: 0))
                            }
                        }
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                flipped.toggle()
                            }
                            changeColor.toggle()
                            reveal.toggle()
                        }
                        .rotation3DEffect(.degrees(flipped ? -180 : 0), axis: (x: 0, y: 1, z: 0))

                        Text("Tap card to flip")
                            .padding(.top)
                            .foregroundColor(.gray)

                        if reveal {
                            HStack(spacing: 52) {
                                Button {
                                    currentIndex = updatedIndex(currentIndex)
                                    flipped.toggle()
                                    reveal.toggle()
                                    changeColor.toggle()
                                } label: {
                                    Image(systemName: "xmark.circle.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 150, height: 115)
                                        .foregroundColor(.red)
                                }
                                
                                Button {
                                    currentIndex = updatedIndex(currentIndex)
                                    flipped.toggle()
                                    reveal.toggle()
                                    changeColor.toggle()

                                } label: {
                                    Image(systemName: "checkmark.circle.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 150, height: 115)
                                        .foregroundColor(.green)
                                }
                            }
                            .padding(.top)
                        }
                        
                        Spacer()
                    }
                }
            }
            .padding(.top)
            .tabViewStyle(.page(indexDisplayMode: .never))

            .navigationTitle("Flashcard \(flashcards[currentIndex].flashcardId)")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading:
                Button {
                    showingAlert.toggle()
                } label: {
                    Image(systemName: "chevron.left")
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
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(Color("DeckColor"), for: .navigationBar)
        }
    }

    func updatedIndex(_ index: Int) -> Int {
        if index == deck.numberPerTest - 1 {
            dismiss()
            return index % deck.numberPerTest
        }
        return index + 1
    }
}

struct FlashcardView_Previews: PreviewProvider {
    static var previews: some View {
        FlashcardView(flashcards: LoadDecksFromJson().decks[0].flashcards, deck: LoadDecksFromJson().decks[0])
    }
}
