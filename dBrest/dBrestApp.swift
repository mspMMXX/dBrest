//
//  dBrestApp.swift
//  dBrest
//
//  Created by Markus Platter on 25.03.25.
//

import SwiftUI
import SwiftData
import UserNotifications

@main
struct dBrestApp: App {
    
    init () {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
                if granted {
                print("Permission granted: \(granted)")
            } else {
                print("Permission denied: \(granted)")
            }
        }
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
        }
        .modelContainer(for: Mixprofile.self)
    }
}
