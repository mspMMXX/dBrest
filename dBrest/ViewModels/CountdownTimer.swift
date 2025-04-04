//
//  CountdownTimer.swift
//  dBrest
//
//  Created by Markus Platter on 28.03.25.
//

import Foundation
import SwiftUI
import UserNotifications

class CountdownTimer: ObservableObject {
    @Published var phaseName: String = "Mix"
    @Published var isMixing: Bool = false
    @Published var remainingTime: Int = 0
    @Published var progress: CGFloat = 0
    @Published var isPaused: Bool = false
    private var currentIndex: Int = 1
    
    private var elapsedMixTime = 0
    private var elapsedPauseTime = 0

    var timer: Timer?
    var mixprofile: Mixprofile
    
    init(mixprofile: Mixprofile) {
        self.mixprofile = mixprofile
    }
    
    func startTimer() {
        runCycle(index: 1)
    }

    func runCycle(index: Int, resume: Bool = false) {
        if !resume { currentIndex = index }
        if index > mixprofile.cycleCount {
            phaseName = "Ende"
            notifyPhaseEnded(phaseName: "Cycle")
            isMixing = false
            mixprofile.counter = mixprofile.cycleCount
            return
        }

        currentIndex = index
        phaseName = "Mix"
        notifyPhaseEnded(phaseName: "Pause")
        isMixing = true
        let totalTime = mixprofile.mixDurationInSeconds
        if !resume { elapsedMixTime = 0 }
        let step = 1.0 / CGFloat(totalTime)

        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { t in
            self.elapsedMixTime += 1
            self.remainingTime = totalTime - self.elapsedMixTime
            self.progress = CGFloat(self.elapsedMixTime) * step

            if self.elapsedMixTime >= totalTime {
                t.invalidate()
                self.runPauseCycle(index: index)
            }
        }
    }
    
    func pauseTimer() {
        timer?.invalidate()
        isPaused = true
    }

    func resumeTimer() {
        isPaused = false
        if phaseName == "Mix" {
            runCycle(index: currentIndex, resume: true)
        } else if phaseName == "Pause" {
            runPauseCycle(index: currentIndex)
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        isMixing = false
        isPaused = false
        progress = 0
        remainingTime = 0
        phaseName = "Gestoppt"
        currentIndex = 1
    }

    func runPauseCycle(index: Int) {
        phaseName = "Pause"
        notifyPhaseEnded(phaseName: "Mix")
        isMixing = false
        remainingTime = mixprofile.pauseDurationInSeconds
        progress = 0
        var elapsed = 0
        let pauseStep = 1.0 / CGFloat(mixprofile.pauseDurationInSeconds)
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { t in
            elapsed += 1
            self.remainingTime = self.mixprofile.pauseDurationInSeconds - elapsed
            self.progress = CGFloat(elapsed) * pauseStep
            
            if elapsed >= self.mixprofile.pauseDurationInSeconds {
                t.invalidate()
                self.mixprofile.counter += 1
                self.runCycle(index: index + 1)
            }
        }
    }
    
    func updateProfile(to newProfile: Mixprofile) {
        self.mixprofile = newProfile
        self.progress = 0
        self.remainingTime = newProfile.mixDurationInMinutes
        self.phaseName = "Mix"
    }
    
    func notifyPhaseEnded(phaseName: String) {
        let content = UNMutableNotificationContent()
        content.title = "🔔 \(phaseName) Phase beendet!"
        content.body = "Die \(phaseName)-Phase ist vorbei"
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
        
    }

}
