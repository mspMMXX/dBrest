//
//  CycleInterval.swift
//  dBrest
//
//  Created by Markus Platter on 31.03.25.
//

enum CycleInterval: Int, CaseIterable, Identifiable {
    case one = 1
    case two = 2
    case three = 3
    case four = 4
    case five = 5
    case six = 6
    case seven = 7
    case eight = 8
    case nine = 9
    case ten = 10
    
    var id: Int {rawValue}
    var label: String {"\(rawValue)"}
}
