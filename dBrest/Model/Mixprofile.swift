//
//  Mixprofile.swift
//  dBrest
//
//  Created by Markus Platter on 26.03.25.
//

import Foundation
import SwiftData

//Model class representing a mix/pause cycle profile
@Model
class Mixprofile: Hashable {
    
    /// Unique identifier for the profile.
    var id: UUID = UUID()
    
    /// Duration of the mix phase in minutes.
    var mixDurationInMinutes: Int = 5
    
    /// Duration of the pause phase in minutes.
    var pauseDurationInMinutes: Int = 1
    
    /// Display name for the profile.
    var name: String

    /// Number of mix/pause cycles to run.
    var cycleCount: Int

    /// Current progress counter (can be used to track cycles).
    var counter: Int = 1

    /// Computed duration of the mix phase in seconds.
    var mixDurationInSeconds: Int {
        mixDurationInMinutes * 60
    }

    /// Computed duration of the pause phase in seconds.
    var pauseDurationInSeconds: Int {
        pauseDurationInMinutes * 60
    }
    
    init(name: String, mixDurationInMinutes: Int, pauseDurationInMinutes: Int, cycleCount: Int) {
        guard !name.isEmpty else {
            fatalError("Name must not be empty")
        }
        guard mixDurationInMinutes >= 0 else {
            fatalError("mixDurationInMinutes must be greate than 0")
        }
        guard pauseDurationInMinutes >= 0 else {
            fatalError("pauseDurationInMinutes must be greate than 0")
        }
        guard cycleCount >= 1 else {
            fatalError("cycleCount must be greate than 1")
        }
        
        self.name = name
        self.mixDurationInMinutes = mixDurationInMinutes
        self.pauseDurationInMinutes = pauseDurationInMinutes
        self.cycleCount = cycleCount
    }
}
