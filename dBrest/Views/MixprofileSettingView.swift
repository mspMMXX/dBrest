//
//  MixprofileSettingView.swift
//  dBrest
//
//  Created by Markus Platter on 31.03.25.
//

import SwiftUI

struct MixprofileSettingView: View {
    
    @State var mixTime: TimeValues = .twenty
    @State var pauseTime: TimeValues = .five
    @State var cycleCount: CycleValues = .one
    @State var mixProfileName: String = ""
    
    @Binding var showSettings: Bool
    
    //SwiftData modelContext - to save the mixprofile
    @Environment(\.modelContext) var modelContext
    
    var body: some View {
        VStack {
            TextField("Name", text: $mixProfileName)
                .frame(maxWidth: 200)
                .padding(20)
            
            Picker("Mix:", selection: $mixTime) {
                ForEach(TimeValues.allCases) { interval in
                    Text(interval.label).tag(interval)
                }
            }
            .frame(maxWidth: 180)
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
            
            Picker("Pause:", selection: $pauseTime) {
                ForEach(TimeValues.allCases) { interval in
                    Text(interval.label).tag(interval)
                }
            }
            .frame(maxWidth: 180)
            .padding(.horizontal,20)
            .padding(.bottom, 20)
            
            Picker("Wiederholungen:", selection: $cycleCount) {
                ForEach(CycleValues.allCases) { interval in
                    Text(interval.label).tag(interval)
                }
            }
            .frame(maxWidth: 150)
            .padding(.horizontal,20)
            .padding(.bottom, 20)
            
            Button {
                let newMixprofile = Mixprofile(name: mixProfileName, mixDurationInMinutes: mixTime.rawValue, pauseDurationInMinutes: pauseTime.rawValue, cycleCount: cycleCount.rawValue)
                modelContext.insert(newMixprofile)
                showSettings = false
                
            } label: {
                Text("Speichern")
            }
            .padding(.horizontal,20)
            .padding(.bottom, 5)
            
            Button {
                showSettings = false
            } label: {
                Text("Abbrechen")
            }
            .padding(.horizontal,20)
            .padding(.bottom, 20)

        }
        .frame(minWidth: 100, minHeight: 100)
    }
}
