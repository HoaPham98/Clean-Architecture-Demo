//
//  SearchServiceType.swift
//  Domain
//
//  Created by Admin on 21/06/2021.
//

import RxSwift

public typealias ResultRange = Range<Substring.Index>

public struct SearchResult: Hashable {
    public let index: Int
    public let score: Double
    public let ranges: [ResultRange]
    
    public init(index: Int, score: Double, ranges: [ResultRange]) {
        self.index = index
        self.score = score
        self.ranges = ranges
    }
    
    public static func ==(lhs: SearchResult, rhs: SearchResult) -> Bool {
        return lhs.index == rhs.index
    }
}

public protocol SearchServiceType {
    func search(_ text: String, in aList: [String]) -> Single<[SearchResult]>
}
