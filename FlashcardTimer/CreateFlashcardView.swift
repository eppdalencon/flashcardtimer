//
//  CreateFlashcardView.swift
//  FlashcardTimer
//
//  Created by Leandro Silva on 08/05/23.
//

import SwiftUI

struct CreateFlashcardView: View {
    var deckId: Int
    @State private var question: String = ""
    @State private var answer: String = ""
    @State private var flipped = false
    @State private var changeColor = true
    @State private var reveal = false
    @State private var showFlashmark = false

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
                Text(reveal ? "Go to answer" : "Go to question")
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

struct CreateFlashcardView_Previews: PreviewProvider {
    static var previews: some View {
        CreateFlashcardView(deckId: 1)
    }
}
