//
//  ContentView.swift
//  dBrest
//
//  Created by Markus Platter on 25.03.25.
//

import SwiftUI

struct ContentView: View {
    
    @State private var isRunning:  Bool = false
    @State var showSettings: Bool = false
    @State private var selectedProfile: Mixprofile
    
    @StateObject private var countdownTimer: CountdownTimer
    @StateObject private var mixprofileList: MixProfileDataModel = MixProfileDataModel()
    
    init () {
        let initialMixProfile = Mixprofile(name: "Default", mixDurationInMinutes: 5, pauseDurationInMinutes: 2, cycleCount: 4)
        _selectedProfile = State(initialValue: initialMixProfile)
        _countdownTimer = StateObject(wrappedValue: CountdownTimer(mixprofile: initialMixProfile))
    }
    
    var body: some View {
        VStack {
            ZStack {
                HStack {
                    Spacer()
                    Button {
                        showSettings = true
                    } label: {
                        Image(systemName: "plus.circle")
                    }
                    .sheet(isPresented: $showSettings) {
                        MixprofileSettingView(showSettings: $showSettings, mixprofileDataModel: mixprofileList)
                    }
                }
                
                Picker("",selection: $selectedProfile) {
                    ForEach(mixprofileList.mixProfiles, id: \.name) { profile in
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
