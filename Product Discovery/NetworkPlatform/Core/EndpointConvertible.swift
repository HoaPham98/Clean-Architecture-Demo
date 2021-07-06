//
//  EndpointConvertible.swift
//  NetworkPlatform
//
//  Created by HoaPQ on 4/24/21.
//

import Foundation
import Alamofire

protocol EndpointConvertible {
    func asURLRequest(configuration: NetworkConfiguration) throws -> URLRequest
}

