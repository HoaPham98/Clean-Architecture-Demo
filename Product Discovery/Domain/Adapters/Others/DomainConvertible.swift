//
//  DomainConvertible.swift
//  Domain
//
//  Created by HoaPQ on 4/24/21.
//

import Foundation

public protocol DomainConvertible {
    associatedtype DomainType
    func asDomain() -> DomainType
}
