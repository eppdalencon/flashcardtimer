//
//  TimerView.swift
//  FlashcardTimer
//
//  Created by Luciana Lemos on 11/05/23.
//

import SwiftUI

struct TimerView: View {
    @State private var alarme = Date()
    @State private var show = false
    @State private var showingAlert = false
    var hourRecieved: Int
    var minuteRecieved: Int
    var index: Int
    var isEditing: Bool
    
    @Environment(\.dismiss) var dismiss
    @Binding var alarmsArray: [[Int]]
    
    init(alarmsArray: Binding<[[Int]]>) {
        self._alarmsArray = alarmsArray
        hourRecieved = 19
        minuteRecieved = 30
        index = 0
        isEditing = false
    }
    
    init(alarmsArray: Binding<[[Int]]>, hourRecieved: Int, minuteRecieved: Int, index: Int) {
        self._alarmsArray = alarmsArray
        self.hourRecieved = hourRecieved
        self.minuteRecieved = minuteRecieved
        self.index = index
        isEditing = true
    }
    
    var numero = 15
    
    var body: some View {
        NavigationStack{
            VStack {
                VStack(alignment: .leading) {
                    Button {
                        showingAlert = true
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
                    
                    Spacer()
                    
                    DatePicker("", selection: $alarme, displayedComponents: .hourAndMinute)
                        .datePickerStyle(.wheel)
                        .labelsHidden()
                    
                    Spacer()
                }
                
                Button {
                    let calendar = Calendar.current
                    let hour = calendar.component(.hour, from: alarme)
                    let minute = calendar.component(.minute, from: alarme)
                    
                    if !isEditing {
                        let hourAndMinute: [Int] = [hour, minute]
                        alarmsArray.append(hourAndMinute)
                    } else {
                        alarmsArray[index][0] = hour
                        alarmsArray[index][1] = minute
                    }
                    
                    dismiss()
                } label: {
                    ZStack {
                        Rectangle()
                            .frame(width: 80, height: 40)
                            .foregroundColor(Color("ButtonAction"))
                            .cornerRadius(10)
                        
                        Text("Set")
                            .foregroundColor(.white)
                    }
                }
                .offset(y: -230)
                
            }
            .onAppear {
                var components = DateComponents()
                components.hour = hourRecieved
                components.minute = minuteRecieved
                
                alarme = Calendar.current.date(from: components)!
            }
        }
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView(alarmsArray: .constant([[1, 2]]))
    }
}
