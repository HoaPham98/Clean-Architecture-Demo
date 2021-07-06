//
//  String+Date.swift
//  Domain
//
//  Created by Admin on 06/07/2021.
//

import Foundation

extension String {
    var date: Date? {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'hh:MM:ssZ"
        return formatter.date(from: self)
    }
}
