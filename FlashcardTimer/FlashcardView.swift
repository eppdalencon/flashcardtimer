//
//  FlashcardView.swift
//  FlashcardTimer
//
//  Created by Arthur Sobrosa on 08/05/23.
//

import SwiftUI

struct FlashcardView: View {
    var deck: Deck
    @State var currentIndex = 0
    
    @State private var flipped = false
    @State private var changeColor = true
    @State private var reveal = false
    @State private var showFlashmark = false
    
    var body: some View {
        NavigationStack {
            TabView(selection: $currentIndex) {
                ForEach(deck.flashcards.indices, id: \.self) { index in
                    VStack {
                        ZStack {
                            Rectangle()
                                .frame(width: 342, height: 430)
                                .cornerRadius(8)
                                .foregroundColor(changeColor ? Color("FlashcardQuestionColor") : Color("FlashcardAnswerColor"))
                            
                            if !flipped {
                                Text(deck.flashcards[index].question)
                                    .frame(width: 340)
                                    .font(.title3)
                                    .rotation3DEffect(.degrees(flipped ? 180 : 0), axis: (x: 0, y: 1, z: 0))
                            } else {
                                Text(deck.flashcards[index].answer)
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
                    }
                }
            }
            .tabViewStyle(PageTabViewStyle())
            
            HStack(spacing: 52) {
                Button() {
                    currentIndex = (currentIndex + 1) % deck.flashcards.count
                    flipped.toggle()
                    reveal.toggle()
                    changeColor.toggle()
                } label: {
                    Image(systemName: "checkmark.circle.fill")
                        .resizable()
                        .frame(width: 108, height: 115)
                        .foregroundColor(.green)
                        .opacity(reveal ? 1 : 0)
                }
                
                Button() {
                    currentIndex = (currentIndex + 1) % deck.flashcards.count
                    flipped.toggle()
                    reveal.toggle()
                    changeColor.toggle()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .frame(width: 108, height: 115)
                        .foregroundColor(.red)
                        .opacity(reveal ? 1 : 0)
                }
            }
            .navigationTitle("Flashcard \(deck.flashcards[currentIndex].flashcardId)")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct FlashcardView_Previews: PreviewProvider {
    static var previews: some View {
        FlashcardView(deck: ModelData().decks[0])
    }
}
