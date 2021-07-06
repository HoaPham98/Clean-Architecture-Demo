//
//  DemoError.swift
//  Domain
//
//  Created by HoaPQ on 4/24/21.
//

import Foundation

public enum DemoError: Error {
    case noInternet
    case httpError(statusCode: Int)
    case other(error: Error)
}

public protocol DomainErrorConvertible {
    func asDomainError() -> DemoError
}

extension DemoError: DomainErrorConvertible {
    public func asDomainError() -> DemoError {
        return self
    }
}

public extension Error {
    func asDemoError() -> DemoError {
        (self as? DomainErrorConvertible)?.asDomainError() ?? .other(error: self)
    }
}
