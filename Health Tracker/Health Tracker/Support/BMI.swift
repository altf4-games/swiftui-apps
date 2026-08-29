//
//  BMI.swift
//  Health Tracker
//

import SwiftUI

enum BMICategory: CaseIterable {
    case underweight, normal, overweight, obese

    init(bmi: Double) {
        switch bmi {
        case ..<18.5: self = .underweight
        case 18.5..<25: self = .normal
        case 25..<30: self = .overweight
        default: self = .obese
        }
    }

    var label: String {
        switch self {
        case .underweight: "Underweight"
        case .normal: "Healthy"
        case .overweight: "Overweight"
        case .obese: "Obese"
        }
    }

    var color: Color {
        switch self {
        case .underweight: Color(hue: 0.55, saturation: 0.65, brightness: 0.85)
        case .normal: Color(hue: 0.38, saturation: 0.6, brightness: 0.75)
        case .overweight: Color(hue: 0.11, saturation: 0.75, brightness: 0.95)
        case .obese: Color(hue: 0.02, saturation: 0.75, brightness: 0.9)
        }
    }

    /// Position of this category's lower bound on a 15...40 BMI scale, 0...1
    var rangeStart: Double {
        switch self {
        case .underweight: 0
        case .normal: (18.5 - 15) / 25
        case .overweight: (25 - 15) / 25
        case .obese: (30 - 15) / 25
        }
    }
}

enum BMI {
    static func value(weightKG: Double, heightCM: Double) -> Double {
        guard heightCM > 0 else { return 0 }
        let heightM = heightCM / 100
        return weightKG / (heightM * heightM)
    }

    /// Normalized 0...1 position on a fixed 15...40 display scale, clamped.
    static func gaugeFraction(_ bmi: Double) -> Double {
        min(max((bmi - 15) / 25, 0), 1)
    }
}
