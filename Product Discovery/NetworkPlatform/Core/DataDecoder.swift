//
//  DataDecoder.swift
//  NetworkPlatform
//
//  Created by HoaPQ on 4/24/21.
//

import Foundation
import Alamofire

/// Any type which can decode `Data` into a `Decodable` type.
public protocol DataDecoder {
    /// Decode `Data` into the provided type.
    ///
    /// - Parameters:
    ///   - type:  The `Type` to be decoded.
    ///   - data:  The `Data` to be decoded.
    ///
    /// - Returns: The decoded value of type `D`.
    /// - Throws:  Any error that occurs during decode.
    func decode<D: Decodable>(_ type: D.Type, from data: Data) throws -> D
}

/// `JSONDecoder` automatically conforms to `DataDecoder`.
extension JSONDecoder: DataDecoder {}

