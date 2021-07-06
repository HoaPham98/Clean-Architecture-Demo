//
//  ProductItemViewModel.swift
//  Domain
//
//  Created by HoaPQ on 4/25/21.
//

import Foundation
import Domain

public struct ProductItemViewModel {
    public let product: ProductItem
    public let ranges: [Range<Substring.Index>]
    
    public init(product: ProductItem, ranges: [Range<Substring.Index>]) {
        self.product = product
        self.ranges = ranges
    }
}
