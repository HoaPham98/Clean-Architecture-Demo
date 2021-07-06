//
//  Application+NetworkProvider.swift
//  Demo Demo
//
//  Created by HoaPQ on 4/24/21.
//

import Domain
import NetworkPlatform
import SearchPlatform

extension Application: NetworkServiceProviderType {
    func makeProductService() -> ProductServiceType {
        return ProductService(network: network)
    }
    
    func makeSearchService() -> SearchServiceType {
        return SearchService()
    }
}
