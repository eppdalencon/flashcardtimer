//
//  OnBoardingView.swift
//  FlashcardTimer
//
//  Created by Arthur Sobrosa on 25/05/23.
//

import SwiftUI

struct OnBoardingView: View {
    @State private var presentContentView: Bool = false
    
    var body: some View {
        ZStack {
            Rectangle().fill(Color("Header").gradient)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Image("Cards")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250)
                
                Image("AppTitle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250)
                    .offset(x: -8, y: -20)
                
                Spacer()
                
                Spacer()
                
                Button {
                    presentContentView.toggle()
                } label: {
                    Text("Get Started")
                        .foregroundColor(Color("ButtonAction"))
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .frame(width: 320)
                                .foregroundColor(.white)
                        )
                }
            }
        }
        .fullScreenCover(isPresented: $presentContentView) {
            ContentView()
        }
    }
}

struct OnBoardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnBoardingView()
    }
}
