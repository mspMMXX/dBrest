//
//  ContentView.swift
//  dBrest
//
//  Created by Markus Platter on 25.03.25.
//

import SwiftUI
import SwiftData

/// Main entry view showing the countdown UI and profile management.
struct MainView: View {
    
    // MARK: - State
    @State private var isRunning: Bool = false
    @State private var showSettings: Bool = false
    @State private var showDeleteAlert: Bool = false
    @State private var selectedProfile: Mixprofile
    @StateObject private var countdownTimer: CountdownTimer

    // MARK: - Data
    @Query var mixprofiles: [Mixprofile]
    @Environment(\.modelContext) var modelContext

    // MARK: - Init
    init() {
        let initialProfile = Mixprofile(name: "Default", mixDurationInMinutes: 5, pauseDurationInMinutes: 2, cycleCount: 4)
        _selectedProfile = State(initialValue: initialProfile)
        _countdownTimer = StateObject(wrappedValue: CountdownTimer(mixprofile: initialProfile))
    }

    // MARK: - View
    var body: some View {
        VStack {
            profilePickerToolbar

            // Shows current phase progress (e.g. 2 / 4)
            Text("Phase: \(countdownTimer.mixprofile.counter)/\(countdownTimer.mixprofile.cycleCount)")
                .font(.headline)
                .padding(.bottom, 20)
            
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
        .padding(20)
        .onAppear {
            // Auto-select first available profile on launch
            if let first = mixprofiles.first {
                selectedProfile = first
                countdownTimer.updateProfile(to: first)
            }
        }
    }

    // MARK: - Toolbar with Picker and Actions
    private var profilePickerToolbar: some View {
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
                .alert("Delete?", isPresented: $showDeleteAlert) {
                    Button("Delete", role: .destructive) {
                        modelContext.delete(selectedProfile)
                        if let first = mixprofiles.first {
                            selectedProfile = first
                            countdownTimer.updateProfile(to: first)
                        }
                        showDeleteAlert = false
                    }
                    Button("Cancel", role: .cancel) {
                        showDeleteAlert = false
                    }
                } message: {
                    Text("Are you sure you want to delete profile \"\(selectedProfile.name)\"?")
                }
            }

            Picker("", selection: $selectedProfile) {
                ForEach(mixprofiles, id: \.name) { profile in
                    Text("\(profile.name) - \(profile.mixDurationInMinutes) / \(profile.pauseDurationInMinutes) min - \(profile.cycleCount) cycles")
                        .tag(profile)
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
    }
}
