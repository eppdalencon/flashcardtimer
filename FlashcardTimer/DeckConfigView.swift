//
//  DeckConfigView.swift
//  FlashcardTimer
//
//  Created by Leandro Silva on 10/05/23.
//

import SwiftUI

struct DeckConfigView: View {
    var deck: Deck
    @State private var showNotification = false
    @State private var alarme = Date()

    @State var alarmsArray: [[Int]] = []
    
    @State var vibrar: Notification = Notification(tipo: "Vibrar", isOn: true)
    @State var tocar: Notification = Notification(tipo: "Tocar", isOn: true)
    
    var body: some View {
        NavigationStack {
            ScrollView {
                Group {
                    VStack(alignment: .leading) {
                        Toggle(isOn: $showNotification) {
                            Text("Notifications")
                                .bold()
                                .font(.title3)
                        }
                        .padding(.trailing)
                        
                        if showNotification == true {
                            Toggle(isOn: $vibrar.isOn) {
                                Text(vibrar.tipo)
                            }
                            .padding(.trailing)
                            
                            Toggle(isOn: $tocar.isOn) {
                                Text(tocar.tipo)
                            }
                            .padding(.trailing)
                        } else {
                            Text("Activate your notifications by clicking the button above")
                                .font(.callout)
                            .foregroundColor(.gray)
                            
                        }
                    }
                }
                
                Divider()
                
                Group {
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Alarm")
                                .bold()
                                .font(.title3)
                            
                            Spacer()
                            
                            NavigationLink(destination: TimerView(alarmsArray: $alarmsArray)) {
                                Image(systemName: "plus")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20)
                                    .foregroundColor(.red)
                                    .offset(x: -10)
                            }
                        }
                        
                        VStack(alignment: .leading) {
                            Text("19:30")
                                .font(.title)
                                .foregroundColor(.black)
                            
                            Text("Alarm")
                                .foregroundColor(.gray)
                        }
                        
                        Divider()
                        
                        ForEach(alarmsArray.indices, id: \.self) { index in
                            let textHour = format(alarmsArray[index][0])
                            let textMinute = format(alarmsArray[index][1])
                            
                            NavigationLink(destination: TimerView(alarmsArray: $alarmsArray, hourRecieved: alarmsArray[index][0], minuteRecieved: alarmsArray[index][1], index: index)) {
                                VStack(alignment: .leading) {
                                    Text("\(textHour):\(textMinute)")
                                        .font(.title)
                                        .foregroundColor(.black)
                                    
                                    Text("Alarm")
                                        .foregroundColor(.gray)
                                    
                                    Divider()
                                }
                            }
                        }
                    }
                }
                .padding(.trailing)
            }
            .padding(.leading)
            .navigationTitle("Notifications Center")
            .navigationBarTitleDisplayMode(.inline)
            .onChange(of: vibrar.isOn) { newValue in
                showNotification = newValue || tocar.isOn
            }
            .onChange(of: tocar.isOn) { newValue in
                showNotification = newValue || vibrar.isOn
            }
        }
    }
    
    func format(_ number: Int) -> String {
        if number < 10 {
            return "0\(number)"
        }
        return "\(number)"
    }
}

struct DeckConfigView_Previews: PreviewProvider {
    static var previews: some View {
        DeckConfigView(deck: LoadDecksFromJson().decks[0])
    }
}
