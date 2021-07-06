//
//  ProductServiceType.swift
//  Domain
//
//  Created by HoaPQ on 4/24/21.
//

import RxSwift
import RxCocoa

public protocol ProductServiceType {
    func getListProduct() -> Single<[ProductItem]>
}
