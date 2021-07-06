//
//  ItemResult.swift
//  Domain
//
//  Created by HoaPQ on 4/24/21.
//

import Foundation
import RxSwift

struct PageItem<Item> {
    var page: Int
    var items: [Item]
    var hasMorePages: Bool
}

struct PageResult<Item> {
    public var page: Observable<PageItem<Item>>
    public var error: Observable<Error>
    public var isLoading: Observable<Bool>
    public var isReloading: Observable<Bool>
    public var isLoadingMore: Observable<Bool>
}

struct ItemResult<Item> {
    public var item: Observable<Item>
    public var error: Observable<Error>
    public var isLoading: Observable<Bool>
    public var isReloading: Observable<Bool>
}

struct ListResult<Item> {
    public var items: Observable<[Item]>
    public var error: Observable<Error>
    public var isLoading: Observable<Bool>
    public var isReloading: Observable<Bool>
}

