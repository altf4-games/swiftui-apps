//
//  WeightEntry.swift
//  Health Tracker
//

import Foundation
import SwiftData

@Model
final class WeightEntry {
    var date: Date
    var weightKG: Double

    init(date: Date = .now, weightKG: Double) {
        self.date = date
        self.weightKG = weightKG
    }
}
