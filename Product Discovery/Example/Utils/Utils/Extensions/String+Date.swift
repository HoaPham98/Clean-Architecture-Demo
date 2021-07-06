//
//  String+Date.swift
//  Domain
//
//  Created by HoaPQ on 4/24/21.
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
