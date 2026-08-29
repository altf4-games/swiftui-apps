//
//  WaterEntry.swift
//  Health Tracker
//

import Foundation
import SwiftData

@Model
final class WaterEntry {
    var date: Date
    var amountML: Int

    init(date: Date = .now, amountML: Int) {
        self.date = date
        self.amountML = amountML
    }
}
