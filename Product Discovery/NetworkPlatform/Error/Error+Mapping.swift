//
//  Error+Mapping.swift
//  NetworkPlatform
//
//  Created by HoaPQ on 4/24/21.
//

import Foundation
import Alamofire
import Domain

extension AFError: DomainErrorConvertible {
    public func asDomainError() -> DemoError {
        if let error = self.underlyingError as NSError?, error.domain == NSURLErrorDomain {
            if error.code == NSURLErrorNotConnectedToInternet {
                return .noInternet
            }
            return .other(error: error)
        }
        
        return (self.underlyingError as? DomainErrorConvertible)?.asDomainError() ?? .other(error: self)
    }
}

extension NetworkError: DomainErrorConvertible {
    func asDomainError() -> DemoError {
        return .other(error: self)
    }
}

extension DemoAPIError: DomainErrorConvertible {
    func asDomainError() -> DemoError {
        switch self {
        case .httpError(let statusCode):
            return .httpError(statusCode: statusCode)
        case .unknownError(let error):
            if (error as NSError).code == NSURLErrorNotConnectedToInternet {
                return .noInternet
            }
            return .other(error: error)
        }
    }
}
