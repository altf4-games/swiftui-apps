//
//  UnitSystem.swift
//  Health Tracker
//

import Foundation

enum UnitSystem: String, CaseIterable, Identifiable {
    case metric
    case imperial

    var id: String { rawValue }
    var label: String { self == .metric ? "Metric" : "Imperial" }
    var weightUnit: String { self == .metric ? "kg" : "lb" }
    var heightUnit: String { self == .metric ? "cm" : "in" }
}

enum Convert {
    static func kgToDisplay(_ kg: Double, _ system: UnitSystem) -> Double {
        system == .metric ? kg : kg * 2.2046226218
    }

    static func displayToKG(_ value: Double, _ system: UnitSystem) -> Double {
        system == .metric ? value : value / 2.2046226218
    }

    static func cmToDisplay(_ cm: Double, _ system: UnitSystem) -> Double {
        system == .metric ? cm : cm / 2.54
    }

    static func displayToCM(_ value: Double, _ system: UnitSystem) -> Double {
        system == .metric ? value : value * 2.54
    }
}
