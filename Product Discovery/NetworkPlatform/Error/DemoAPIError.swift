//
//  DemoAPIError.swift
//  NetworkPlatform
//
//  Created by HoaPQ on 4/24/21.
//

import Foundation

//Error will be used to describe all of Cyfeer API error
enum DemoAPIError: Error {
    case unknownError(Error)
    case httpError(statusCode: Int)
}

extension DemoAPIError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .unknownError:
            return "Demo API error: Unknown error"
        case .httpError(let statusCode):
            return "Demo API error: general failed with \(statusCode)"
        }
    }
}
