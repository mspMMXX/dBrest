//
//  CountdownTimer.swift
//  dBrest
//
//  Created by Markus Platter on 28.03.25.
//

import Foundation
import SwiftUI

class CountdownTimer: ObservableObject {
    @Published var mixPhase: String = "Mix"
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
            mixPhase = "Ende"
            isMixing = false
            mixprofile.counter = mixprofile.cycleCount
            return
        }

        currentIndex = index
        mixPhase = "Mix"
        isMixing = true
        let totalTime = mixprofile.mixDuration
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
        if mixPhase == "Mix" {
            runCycle(index: currentIndex, resume: true)
        } else if mixPhase == "Pause" {
            runPauseCycle(index: currentIndex)
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        isMixing = false
        isPaused = false
        progress = 0
        remainingTime = 0
        mixPhase = "Gestoppt"
        currentIndex = 1
    }

    func runPauseCycle(index: Int) {
        mixPhase = "Pause"
        isMixing = false
        remainingTime = mixprofile.pauseDuration
        progress = 0
        var elapsed = 0
        let pauseStep = 1.0 / CGFloat(mixprofile.pauseDuration)
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { t in
            elapsed += 1
            self.remainingTime = self.mixprofile.pauseDuration - elapsed
            self.progress = CGFloat(elapsed) * pauseStep
            
            if elapsed >= self.mixprofile.pauseDuration {
                t.invalidate()
                self.mixprofile.counter += 1
                self.runCycle(index: index + 1)
            }
        }
    }
    
    func updateProfile(to newProfile: Mixprofile) {
        self.mixprofile = newProfile
        self.progress = 0
        self.remainingTime = newProfile.mixDuration
        self.mixPhase = "Mix"
    }

}
