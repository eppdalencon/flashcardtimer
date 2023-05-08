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
    var body: some View {
        Form {
            Section {
                List{
                    TextField("Question", text: $question)
                        .padding(10)
                    TextField("Answer", text: $answer)
                        .padding(10)
                }
                
                .bold()
                .font(.title3)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(10)
            }
        }
    }
}

struct CreateFlashcardView_Previews: PreviewProvider {
    static var previews: some View {
        CreateFlashcardView(deckId: 1)
    }
}
