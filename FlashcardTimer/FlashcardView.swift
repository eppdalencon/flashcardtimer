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
    
    @State var isPresenting = false
    
    @State private var flipped = false
    @State private var changeColor = true
    @State private var reveal = false
    @State private var showFlashmark = false
    
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
                        .rotation3DEffect(.degrees(flipped ? -180 : 0), axis: (x: 0, y: 1, z: 0))
                        
                        
                        Button {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                flipped.toggle()
                            }
                            changeColor.toggle()
                            reveal.toggle()
                        } label: {
                            Text(reveal ? "Hide" : "Reveal")
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
                        
                        Spacer()
                        
                        if reveal {
                            HStack(spacing: 52) {
                                Button {
                                    currentIndex = updatedIndex(currentIndex)
                                    flipped.toggle()
                                    reveal.toggle()
                                    changeColor.toggle()
                                    
                                } label: {
                                    Image(systemName: "checkmark.circle.fill")
                                        .resizable()
                                        .frame(width: 150, height: 115)
                                        .foregroundColor(.green)
                                }
                                
                                Button {
                                    currentIndex = (currentIndex + 1) % flashcards.count
                                    flipped.toggle()
                                    reveal.toggle()
                                    changeColor.toggle()
                                } label: {
                                    Image(systemName: "xmark.circle.fill")
                                        .resizable()
                                        .frame(width: 150, height: 115)
                                        .foregroundColor(.red)
                                }
                            }
                        }
                        
                        
                    }
                }
            }
            .tabViewStyle(PageTabViewStyle())
            .fullScreenCover(isPresented: $isPresenting) {
                DeckView(deck: deck, number: 1)
            }
            
            .navigationTitle("Flashcard \(flashcards[currentIndex].flashcardId)")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    func updatedIndex(_ index: Int) -> Int {
        if index == flashcards.count - 1 {
            isPresenting.toggle()
            return index % flashcards.count
        }
        return index + 1
    }
}

struct FlashcardView_Previews: PreviewProvider {
    static var previews: some View {
        FlashcardView(flashcards: ModelData().decks[0].flashcards, deck: ModelData().decks[0])
    }
}
