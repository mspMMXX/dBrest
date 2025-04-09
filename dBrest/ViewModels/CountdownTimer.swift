//
//  CountdownTimer.swift
//  dBrest
//
//  Created by Markus Platter on 28.03.25.
//

import Foundation
import SwiftUI
import UserNotifications

/// Handles the countdown logic for alternating mix and pause phases,
/// including Logic Pro window automation and local notifications.
class CountdownTimer: ObservableObject {
    
    // MARK: - Observable properties for UI updates
    @Published var phaseName: String = "Mix"
    @Published var isMixing: Bool = false
    @Published var remainingTime: Int = 0
    @Published var progress: CGFloat = 0
    @Published var isPaused: Bool = false

    // MARK: - Internal state
    private var currentIndex: Int = 1
    private var elapsedMixTime = 0

    // MARK: - Timer and profile
    var timer: Timer?
    var mixprofile: Mixprofile

    // MARK: - Initialization
    init(mixprofile: Mixprofile) {
        self.mixprofile = mixprofile
    }

    // MARK: - Public control methods

    /// Starts the timer from the first cycle.
    func startTimer() {
        runCycle(index: 1)
    }

    /// Pauses the timer and marks the state.
    func pauseTimer() {
        timer?.invalidate()
        isPaused = true
    }

    /// Resumes the timer depending on the current phase.
    func resumeTimer() {
        isPaused = false
        if phaseName == "Mix" {
            runCycle(index: currentIndex, resume: true)
        } else if phaseName == "Pause" {
            runPauseCycle(index: currentIndex)
        }
    }

    /// Stops the timer and resets the state.
    func stopTimer() {
        timer?.invalidate()
        isMixing = false
        isPaused = false
        progress = 0
        remainingTime = 0
        phaseName = "Stopped"
        currentIndex = 1
    }

    /// Updates the current profile and resets timer state.
    func updateProfile(to newProfile: Mixprofile) {
        self.mixprofile = newProfile
        self.progress = 0
        self.remainingTime = newProfile.mixDurationInMinutes
        self.phaseName = "Mix"
    }

    // MARK: - Cycle handling

    /// Runs a single mix cycle.
    private func runCycle(index: Int, resume: Bool = false) {
        if !resume { currentIndex = index }
        if index > mixprofile.cycleCount {
            phaseName = "Done"
            notifyPhaseEnded(phaseName: "Cycle")
            isMixing = false
            mixprofile.counter = 1
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

    /// Runs the pause phase after a mix cycle.
    private func runPauseCycle(index: Int) {
        phaseName = "Pause"
        notifyPhaseEnded(phaseName: "Mix")
        runMinimize()
        isMixing = false
        remainingTime = mixprofile.pauseDurationInSeconds
        progress = 0

        var elapsed = 0
        let step = 1.0 / CGFloat(mixprofile.pauseDurationInSeconds)

        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { t in
            elapsed += 1
            self.remainingTime = self.mixprofile.pauseDurationInSeconds - elapsed
            self.progress = CGFloat(elapsed) * step

            if elapsed >= self.mixprofile.pauseDurationInSeconds {
                t.invalidate()
                self.mixprofile.counter += 1
                self.runCycle(index: index + 1)
            }
        }
    }

    // MARK: - Notifications

    /// Sends a local notification when a phase ends.
    func notifyPhaseEnded(phaseName: String) {
        let content = UNMutableNotificationContent()
        content.title = "🔔 \(phaseName) phase ended!"
        content.body = "The \(phaseName) phase is over."
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request)
    }

    // MARK: - Logic Pro window control

    /// Minimizes Logic Pro using AppleScript.
    func runMinimize() {
        guard isLogicProRunning() else {
            print("Logic Pro is not running – skipping minimize.")
            return
        }

        let script = """
        tell application "System Events"
            set visible of process "Logic Pro" to false
        end tell
        """

        let process = Process()
        process.launchPath = "/usr/bin/osascript"
        process.arguments = ["-e", script]
        process.launch()

        process.terminationHandler = { proc in
            print("AppleScript finished with code \(proc.terminationStatus)")
        }
    }

    /// Brings Logic Pro to front using AppleScript.
    func runMaximize() {
        guard isLogicProRunning() else {
            print("Logic Pro is not running – skipping maximize.")
            return
        }

        let script = """
        tell application "System Events"
            set visible of process "Logic Pro" to true
            set frontmost of process "Logic Pro" to true
        end tell
        """

        let process = Process()
        process.launchPath = "/usr/bin/osascript"
        process.arguments = ["-e", script]

        let pipe = Pipe()
        process.standardOutput = pipe
        process.standardError = pipe

        process.launch()
        process.waitUntilExit()

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        if let output = String(data: data, encoding: .utf8), !output.isEmpty {
            print("AppleScript output: \(output)")
        } else {
            print("No output from script – likely successful or silent.")
        }

        if process.terminationStatus != 0 {
            print("AppleScript returned non-zero exit code: \(process.terminationStatus)")
        }
    }

    /// Checks if Logic Pro is currently running.
    func isLogicProRunning() -> Bool {
        NSWorkspace.shared.runningApplications.contains {
            $0.localizedName == "Logic Pro"
        }
    }
}
