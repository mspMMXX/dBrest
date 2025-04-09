//
//  TimeInterval.swift
//  dBrest
//
//  Created by Markus Platter on 31.03.25.
//

enum TimeValue: Int, CaseIterable, Identifiable {
    case one = 1
    case five = 5
    case ten = 10
    case fifteen = 15
    case twenty = 20
    case twentyFive = 25
    case thirty = 30
    case thirtyFive = 35
    case forty = 40
    case fourtyFive = 45
    case fifty = 50
    case fiftyFive = 55
    case sixty = 60
    
    var id: Int { rawValue }
    
    var label: String {
        "\(rawValue) Minuten"
    }
    
    var seconds: Int {
        rawValue * 60
    }
}
