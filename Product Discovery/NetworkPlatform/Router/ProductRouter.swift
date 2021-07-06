//
//  ProductRouter.swift
//  NetworkPlatform
//
//  Created by HoaPQ on 4/24/21.
//

import Alamofire

enum ProductRouter: EndpointConvertible {
    case getProduct
    
    var method: HTTPMethod {
        return .get
    }
    
    var path: String {
        switch self {
        case .getProduct: return "/v3/7af6f34b-b206-4bed-b447-559fda148ca5"
        }
    }
    
    var parameters: [String: Any] {
        return [:]
    }
    
    func asURLRequest(configuration: NetworkConfiguration) throws -> URLRequest {
        let url = configuration.baseURL.appendingPathComponent(path)
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        let params = self.parameters
        
        if method == .get {
            return try URLEncoding.default.encode(urlRequest, with: params)
        } else {
            return try JSONEncoding.default.encode(urlRequest, with: params)
        }
    }
}
