//
//  DateString.swift
//  mood-tracker
//
//  Created by Lucia Reynoso on 12/6/18.
//  Copyright © 2018 Lucia Reynoso. All rights reserved.
//

import Foundation

extension Date {
    var stringValue: String {
        return DateFormatter.localizedString(from: self, dateStyle: .medium, timeStyle: .short)
    }
}
