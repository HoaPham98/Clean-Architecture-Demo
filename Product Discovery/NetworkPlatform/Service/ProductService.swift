//
//  ProductService.swift
//  NetworkPlatform
//
//  Created by HoaPQ on 4/24/21.
//

import Domain
import Alamofire
import RxSwift

public struct ProductService {
    let network: Network
    
    public init(network: Network) {
        self.network = network
    }
}

extension ProductService: ProductServiceType {
    public func getListProduct() -> Single<[ProductItem]> {
        return network.rx.request(ProductRouter.getProduct)
            .validateDemo()
            .responseDecodable(of: [ProductItemModel].self, useCache: true)
            .map { $0.map { $0.asDomain() } }
    }
}
