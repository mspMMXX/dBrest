//
//  MixprofileSettingView.swift
//  dBrest
//
//  Created by Markus Platter on 31.03.25.
//

import SwiftUI

struct MixprofileSettingView: View {
    
    @State var mixTime: TimeValue = .twenty
    @State var pauseTime: TimeValue = .five
    @State var cycleCount: CycleValue = .one
    @State var mixProfileName: String = ""
    @State private var noNameAlertIsShown: Bool = false
    
    @Binding var showSettings: Bool
    
    // SwiftData modelContext – used to save the mix profile
    @Environment(\.modelContext) var modelContext
    
    var body: some View {
        VStack {
            // Text field for the profile name
            TextField("Name", text: $mixProfileName)
                .frame(maxWidth: 200)
                .padding(20)
            
            // Picker for mix duration
            Picker("Mix:", selection: $mixTime) {
                ForEach(TimeValue.allCases) { interval in
                    Text(interval.label).tag(interval)
                }
            }
            .frame(maxWidth: 180)
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
            
            // Picker for pause duration
            Picker("Pause:", selection: $pauseTime) {
                ForEach(TimeValue.allCases) { interval in
                    Text(interval.label).tag(interval)
                }
            }
            .frame(maxWidth: 180)
            .padding(.horizontal,20)
            .padding(.bottom, 20)
            
            // Picker for cycle count
            Picker("Repetitions:", selection: $cycleCount) {
                ForEach(CycleValue.allCases) { interval in
                    Text(interval.label).tag(interval)
                }
            }
            .frame(maxWidth: 150)
            .padding(.horizontal,20)
            .padding(.bottom, 20)
            
            // Save button
            Button {
                if mixProfileName != "" {
                    let newMixprofile = Mixprofile(
                        name: mixProfileName,
                        mixDurationInMinutes: mixTime.rawValue,
                        pauseDurationInMinutes: pauseTime.rawValue,
                        cycleCount: cycleCount.rawValue
                    )
                    modelContext.insert(newMixprofile)
                    showSettings = false
                } else {
                    noNameAlertIsShown = true
                }
            } label: {
                Text("Save")
            }
            .padding(.horizontal,20)
            .padding(.bottom, 5)
            .alert("No name entered!", isPresented: $noNameAlertIsShown) {
                Button {
                    noNameAlertIsShown = false
                } label: {
                    Text("OK")
                }
            } message: {
                Text("Please enter a name for your mix profile.")
            }
            
            // Cancel button
            Button {
                showSettings = false
            } label: {
                Text("Cancel")
            }
            .padding(.horizontal,20)
            .padding(.bottom, 20)
        }
        .frame(minWidth: 100, minHeight: 100)
    }
}
