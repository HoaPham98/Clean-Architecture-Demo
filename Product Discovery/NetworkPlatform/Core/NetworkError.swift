//
//  NetworkError.swift
//  NetworkPlatform
//
//  Created by HoaPQ on 4/24/21.
//

import Foundation

enum NetworkError: Error {
    enum ResponseSerializationFailureReason {
        case nilDataAtKeyPath(keyPath: String)
        case invalidJSONAtKeyPath(keyPath: String?, value: Any)
    }
    
    case responseSerializationFailed(reason: ResponseSerializationFailureReason)
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .responseSerializationFailed(let reason):
            return reason.localizedDescription
        }
    }
}

extension NetworkError.ResponseSerializationFailureReason {
    var localizedDescription: String? {
        switch self {
        case .nilDataAtKeyPath(let keyPath):
            return "Network: Parsing JSON data failed - nil data at keypath: \(keyPath)"
        case .invalidJSONAtKeyPath(let keyPath, let value):
            guard let keyPath = keyPath else {
                return "Network: Parsing JSON data failed - invalid JSON value: \(value)"
            }

            return "Network: Parsing JSON data failed - invalid JSON at keypath: \(keyPath), value: \(value)"
        }
    }
}
