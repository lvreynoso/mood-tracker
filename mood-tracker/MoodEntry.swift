//
//  MoodEntry.swift
//  
//
//  Created by Lucia Reynoso on 12/6/18.
//

import Foundation
import UIKit

struct MoodEntry {
    var mood: Mood
    var date: Date
    //
    enum Mood: Int {
        case none
        case amazing
        case good
        case neutral
        case bad
        case terrible
        var stringValue: String {
            switch self {
            case .none:
                return ""
            case .amazing:
                return "Amazing"
            case .good:
                return "Good"
            case .neutral:
                return "Neutral"
            case .bad:
                return "Bad"
            case .terrible:
                return "Terrible"
            }
        }
        
        var colorValue: UIColor {
            switch self {
            case .none:
                return .clear
            case .amazing:
                return .green
            case .good:
                return .blue
            case .neutral:
                return .gray
            case .bad:
                return .orange
            case .terrible:
                return .red
            }
        }
    }
}
