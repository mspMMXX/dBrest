//
//  ContentView.swift
//  dBrest
//
//  Created by Markus Platter on 25.03.25.
//

import SwiftUI

struct ContentView: View {
    
    @State private var mixprofileName: String = "MixprofileName"
    @State private var phaseName: String = "Mix-Phase"
    @State private var cycleCount: Int = 2
    @State private var isRunning:  Bool = false
    
    //selectedOption mit Datentyp Mixprofile ändern
    @State var selectedOption: String = "Test"
    
    //List mit Mixprofil-Liste ersetzen
    let list = ["Test, 1", "Test, 2", "Test, 3"]
    
    @State var mixProfile = Mixprofile(name: "Default 30/10", mixDuration: 5, pauseDuration: 1, cycleCount: 3)
    
    var body: some View {
        VStack {
            ZStack {
                HStack {
                    Spacer()
                    Button {
                        print("Neues Mixprofil anlegen")
                    } label: {
                        Image(systemName: "plus.circle")
                    }

                }
                Picker("",selection: $selectedOption) {
                    ForEach(list, id: \.self) { item in
                        Text(item)
                            .font(.headline)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .frame(maxWidth: 250)
                .padding(20)
            }
            
            Text("Wiederholung: \(cycleCount)")
                .font(.headline)
                
            ZStack {
                if isRunning {
                    CircularCountdownView(cycleCount: $mixProfile.cycleCount, mixDuration: $mixProfile.mixDuration, pauseDuration: $mixProfile.pauseDuration)
                        .padding(20)
                } else {
                    Button {
                        isRunning.toggle()
                    } label: {
                        Image(systemName: "play.circle")
                            .font(.system(size: 100))
                    }
                    .buttonStyle(.plain)
                }
            }
            .frame(minWidth: 200, minHeight: 250)
            
        }
        .padding(20)
    }
}

#Preview {
    ContentView()
}
