//
//  ContentView.swift
//  dBrest
//
//  Created by Markus Platter on 25.03.25.
//

import SwiftUI
import SwiftData

struct MainView: View {
    
    @State private var isRunning:  Bool = false
    @State var showSettings: Bool = false
    @State private var selectedProfile: Mixprofile
    @State private var showDeleteAlert: Bool = false
    @StateObject private var countdownTimer: CountdownTimer
    
    @Query var mixprofiles: [Mixprofile]
    @Environment(\.modelContext) var modelContext
    
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
                        MixprofileSettingView(showSettings: $showSettings)
                    }

                    Button {
                        showDeleteAlert = true
                    } label: {
                        Image(systemName: "trash")
                    }
                    .alert("Löschen?", isPresented: $showDeleteAlert) {
                        Button {
                            modelContext.delete(selectedProfile)
                            if let first = mixprofiles.first {
                                selectedProfile = first
                                countdownTimer.updateProfile(to: first)
                            }
                            showDeleteAlert = false
                        } label: {
                            Text("Löschen")
                        }
                        Button {
                            showDeleteAlert = false
                        } label: {
                            Text("Abbrechen")
                        }
                    } message: {
                        Text("Möchten Sie das Mixprofil -\(selectedProfile.name)- wirklich löschen?")
                    }

                }
                
                Picker("", selection: $selectedProfile) {
                    ForEach(mixprofiles, id: \.name) { profile in
                        Text("\(profile.name) - \(profile.mixDurationInMinutes) min. \(profile.pauseDurationInMinutes) min. \(profile.cycleCount) cycles").tag(profile)
                            .font(.headline)
                    }
                }
                .onChange(of: selectedProfile) {
                    countdownTimer.updateProfile(to: selectedProfile)
                    isRunning = false
                }
                .pickerStyle(.menu)
                .frame(maxWidth: 250)
                .padding(20)
            }
            
            Text("Phase: \(countdownTimer.mixprofile.counter)/\(countdownTimer.mixprofile.cycleCount) ")
                .padding(.bottom, 20)
                .font(.headline)
            
            ZStack {
                if isRunning {
                    CircularTimerView(countdownTimer: countdownTimer)
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
            .frame(minWidth: 450, minHeight: 250)
        }
        .onAppear {
            if let first = mixprofiles.first {
                selectedProfile = first
                countdownTimer.updateProfile(to: first)
            }
        }
        .padding(20)
    }
}
