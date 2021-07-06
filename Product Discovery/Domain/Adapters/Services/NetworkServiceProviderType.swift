//
//  NetworkServiceProviderType.swift
//  Domain
//
//  Created by HoaPQ on 4/24/21.
//

import Foundation

public protocol NetworkServiceProviderType {
    func makeProductService() -> ProductServiceType
    func makeSearchService() -> SearchServiceType
}
