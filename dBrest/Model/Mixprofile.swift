//
//  Mixprofile.swift
//  dBrest
//
//  Created by Markus Platter on 26.03.25.
//

import Foundation

struct Mixprofile: Hashable {
    var name: String
    var mixDuration: Int
    var pauseDuration: Int
    var cycleCount: Int
    var counter: Int = 1
}
