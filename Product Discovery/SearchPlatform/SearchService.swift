//
//  SearchService.swift
//  SearchPlatform
//
//  Created by Admin on 21/06/2021.
//

import Domain
import RxSwift

public struct SearchService {
    let matcher: SmartSearchMatcher
    public init() {
        self.matcher = SmartSearchMatcher()
    }
}

extension SearchService: SearchServiceType {
    public func search(_ text: String, in aList: [String]) -> Single<[SearchResult]> {
        return Single.create { single in
            matcher.search(text, in: aList) {
                single(.success($0))
            }
            return Disposables.create()
        }
    }
}
