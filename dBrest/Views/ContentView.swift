//
//  ContentView.swift
//  dBrest
//
//  Created by Markus Platter on 25.03.25.
//

import SwiftUI

struct ContentView: View {
    
    @State private var isRunning:  Bool = false
    @StateObject private var countdownTimer: CountdownTimer
    @State private var selectedProfile: Mixprofile
    
    let mixprofiles: [Mixprofile] = [
        Mixprofile(name: "Default", mixDuration: 30, pauseDuration: 5, cycleCount: 7),
        Mixprofile(name: "Lang", mixDuration: 60, pauseDuration: 10, cycleCount: 2),
        Mixprofile(name: "Kurz", mixDuration: 5, pauseDuration: 2, cycleCount: 3)
    ]

    init () {
        let initialMixProfile = Mixprofile(name: "Default", mixDuration: 30, pauseDuration: 5, cycleCount: 3)
        _selectedProfile = State(initialValue: initialMixProfile)
        _countdownTimer = StateObject(wrappedValue: CountdownTimer(mixprofile: initialMixProfile))
    }
    
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
                Picker("",selection: $selectedProfile) {
                    ForEach(mixprofiles, id: \.name) { profile in
                        Text(profile.name).tag(profile)
                            .font(.headline)
                    }
                }
                .onChange(of: selectedProfile) {
                    countdownTimer.updateProfile(to: selectedProfile)
                    isRunning = false
                }
                .pickerStyle(MenuPickerStyle())
                .frame(maxWidth: 250)
                .padding(20)
            }
            
            Text("Phase: \(countdownTimer.mixprofile.counter)/\(countdownTimer.mixprofile.cycleCount) ")
                .padding(.bottom, 20)
                .font(.headline)
                
            ZStack {
                if isRunning {
                    CircularCountdownView(countdownTimer: countdownTimer)
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
            .frame(minWidth: 150, minHeight: 250)
            
        }
        .padding(20)
    }
}

#Preview {
    ContentView()
}
