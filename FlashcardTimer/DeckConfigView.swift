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
    @State private var presentTimerView = false
    @State private var showingAlert = false
    @State private var alarmsArray: [[Int]] = []
    
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                Group {
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Alarm")
                                .bold()
                                .font(.title3)
                            
                            Spacer()
                            
                            Button {
                                presentTimerView.toggle()
                            } label: {
                                Image(systemName: "plus")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20)
                                    .foregroundColor(.red)
                                                                }
                        }
                        
                        
                        
                        Divider()
                        
                        ForEach(alarmsArray.indices, id: \.self) { index in
                            let textHour = format(alarmsArray[index][0])
                            let textMinute = format(alarmsArray[index][1])
                            VStack{
                                HStack{
                                    NavigationLink(destination: TimerView(alarmsArray: $alarmsArray, hourRecieved: alarmsArray[index][0], minuteRecieved: alarmsArray[index][1], index: index)) {
                                        VStack{
                                            HStack{
                                                VStack(alignment: .leading) {
                                                    Text("\(textHour):\(textMinute)")
                                                        .font(.title)
                                                        .foregroundColor(.black)
                                                    
                                                    Text("Alarm")
                                                        .foregroundColor(.gray)
                                                    
                                                   
                                                    
                                                    
                                                    
                                                    
                                                }
                                                Spacer()
                                                
                                                
                                
                                            }
                                            
                                            
                                        }
                                        
                                        
                                    }
                                    
                                    Spacer()
                                    
                                    Button{
                                        alarmsArray.remove(at: index)
                                    }label: {
                                        Image(systemName: "minus")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 20)
                                            .foregroundColor(.red)
                                            
                                    }
                                }
                                Divider()
                            }
                            
                            
                           
                        }
                    }
                }
                .padding(.trailing)
            }
            .navigationBarItems(leading:
                Button {
                showingAlert.toggle()
                } label: {
                    Text("Cancel")
                        .foregroundColor(.red)
                }
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text("Are you sure you want to go back?"), message: nil, primaryButton: .destructive( Text("Yes"), action: {
                            dismiss()
                        }),
                        secondaryButton: .cancel(Text("No"))
                    )
                }
            )
            .navigationTitle("Notifications")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(Color("DeckColor"), for: .navigationBar)
            .navigationBarItems(trailing:
                Button {
                
                    ReminderNotification.removeNotifications(deckId: deck.deckId){
                        ReminderNotification.setupNotifications(deckId: deck.deckId, notificationText: "Testando", times: alarmsArray)
                            dismiss()
                    }
                
               
                } label : {
                    Text("Save")
                        .foregroundColor(.blue)
                }
            )
            .padding([.top, .leading])
            .fullScreenCover(isPresented: $presentTimerView) {
                TimerView(alarmsArray: $alarmsArray)
            }
//
            .onAppear {
                
                ReminderNotification.listNotifications(deckId: deck.deckId) { alarms in
                        self.alarmsArray = alarms
                    }
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
