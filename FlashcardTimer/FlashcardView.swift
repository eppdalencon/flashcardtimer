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
                                .foregroundColor(Color("FlashcardColor"))
                                .shadow(color: .gray, radius: 4, x: 0, y: 4)

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
                            reveal.toggle()
                        }
                        .rotation3DEffect(.degrees(flipped ? -180 : 0), axis: (x: 0, y: 1, z: 0))

                        Text("Tap card to flip")
                            .padding(.top)
                            .foregroundColor(.gray)

                        Spacer()
                        
                        if reveal {
                            Button {
                                currentIndex = updatedIndex(currentIndex)
                                flipped.toggle()
                                reveal.toggle()

                            } label: {
                                ZStack {
                                    Rectangle()
                                        .frame(width: 100, height: 70)
                                        .cornerRadius(10)
                                        .foregroundColor(Color("ButtonAction"))
                                    Text("Next")
                                        .font(.title)
                                    .foregroundColor(.white)
                                }
                            }
                        }
                        
                        Spacer()
                    }
                }
            }
            .padding(.top)
            .tabViewStyle(.page(indexDisplayMode: .never))
            .navigationTitle("Flashcard \(flashcards[currentIndex].flashcardId)")
            .toolbarColorScheme(.dark, for: .navigationBar)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading:
                Button {
                    showingAlert.toggle()
                } label: {
                    Image(systemName: "chevron.left")
                        
                    Text("Back")
                }
                .foregroundColor(Color("Background"))
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text("Are you sure you want to go back?"), message: nil, primaryButton: .destructive( Text("Yes"), action: {
                            dismiss()
                        }),
                        secondaryButton: .cancel(Text("No"))
                    )
                }
            )
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(Color("Header"), for: .navigationBar)
        }
        .preferredColorScheme(.light)
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
