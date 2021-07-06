//
//  ProductItemModel.swift
//  NetworkPlatform
//
//  Created by HoaPQ on 4/24/21.
//

import Foundation
import Domain

struct ProductItemModel: Decodable, DomainConvertible {
    let id: Int
    let name: String
    let imageUrl: String
    let dateAdded: String
    let dateUpdated: String
    let price: Double
    let brand: String
    let code: String
    
    func asDomain() -> ProductItem {
        return ProductItem(id: id, name: name, imageUrl: imageUrl, dateAdded: dateAdded, dateUpdated: dateUpdated, price: price, brand: brand, code: code)
    }
}
