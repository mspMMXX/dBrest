//
//  Mixprofile.swift
//  dBrest
//
//  Created by Markus Platter on 26.03.25.
//

import Foundation

struct Mixprofile: Hashable {
    
    var mixDurationInMinutes: Int = 5
    var pauseDurationInMinutes: Int = 1
    var name: String
    var mixDurationInSeconds: Int { mixDurationInMinutes * 60 }
    var pauseDurationInSeconds: Int { pauseDurationInMinutes * 60 }
    var cycleCount: Int
    var counter: Int = 1
    
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
