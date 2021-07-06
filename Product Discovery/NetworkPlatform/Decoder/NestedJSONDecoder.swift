//
//  NestedJSONDecoder.swift
//  NetworkModule
//
//  Created by Z on 12/25/19.
//  Copyright © 2019 Zen8Labs. All rights reserved.
//

import Foundation
import Alamofire

//This is a convenience decoder, actually it's not very good in performance point of view, but it's very handy
class NestedJSONDecoder: DataDecoder {
    let keyPath: String
    let readingOptions: JSONSerialization.ReadingOptions
    let decoder: DataDecoder
    
    init(keyPath: String,
         decoder: DataDecoder,
         readingOptions: JSONSerialization.ReadingOptions) {
        self.keyPath = keyPath
        self.readingOptions = readingOptions
        self.decoder = decoder
    }
    
    func decode<D: Decodable>(_ type: D.Type, from data: Data) throws -> D {
        let json = try JSONSerialization.jsonObject(with: data, options: readingOptions)
     
        guard let nestedJson = (json as AnyObject).value(forKeyPath: keyPath) else {
            let error = NetworkError.responseSerializationFailed(reason: .nilDataAtKeyPath(keyPath: keyPath))
            throw error
        }
        
        guard JSONSerialization.isValidJSONObject(nestedJson) else {
            let error = NetworkError.responseSerializationFailed(reason: .invalidJSONAtKeyPath(keyPath: keyPath, value: nestedJson))
            throw error
        }
        
        let nestedData = try JSONSerialization.data(withJSONObject: nestedJson)
        return try decoder.decode(type, from: nestedData)
    }
}
