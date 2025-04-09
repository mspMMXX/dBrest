//
//  CycleInterval.swift
//  dBrest
//
//  Created by Markus Platter on 31.03.25.
//

enum CycleValue: Int, CaseIterable, Identifiable {
    case one = 1, two, three, four, five, six, seven, eight, nine, ten
    
    var id: Int { rawValue }
    var label: String { String(rawValue) }
}
