//
//  Sequence+.swift
//  Domain
//
//  Created by HoaPQ on 4/25/21.
//

import Foundation

extension Sequence where Element: Hashable {
    func uniqued() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}
