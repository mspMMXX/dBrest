//
//  dBrestApp.swift
//  dBrest
//
//  Created by Markus Platter on 25.03.25.
//

import SwiftUI
import SwiftData

@main
struct dBrestApp: App {
    var body: some Scene {
        WindowGroup {
            MainView()
        }
        .modelContainer(for: Mixprofile.self)
    }
}
