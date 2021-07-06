//
//  ProductItem.swift
//  Domain
//
//  Created by HoaPQ on 4/24/21.
//

import Foundation

public struct ProductItem {
    public let id: Int
    public let name: String
    public let imageUrl: String
    public let dateAdded: Date?
    public let dateUpdated: Date?
    public let price: Double
    public let brand: String
    public let code: String
    
    public init(id: Int, name: String, imageUrl: String, dateAdded: String, dateUpdated: String, price: Double, brand: String, code: String) {
        self.id = id
        self.name = name
        self.imageUrl = imageUrl
        self.dateAdded = dateAdded.date
        self.dateUpdated = dateUpdated.date
        self.price = price
        self.brand = brand
        self.code = code
    }
}
