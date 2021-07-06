//
//  SmartSearchMatcher.swift
//  Domain
//
//  Created by HoaPQ on 4/25/21.
//

import Domain
import RxSwift

typealias Pattern = [String.SubSequence]

/// Search string matcher using token prefixes.
class SmartSearchMatcher {

    fileprivate lazy var searchQueue: DispatchQueue = { [unowned self] in
        let label = "mespi.search.queue"
        return DispatchQueue(label: label, attributes: .concurrent)
    }()
    
    func createPattern(searchString: String) -> [String.SubSequence] {
        return searchString.split(whereSeparator: { $0.isWhitespace })
    }

    /// Check if `candidateString` matches `searchString`.
    fileprivate func matches(_ pattern: Pattern, in candidateString: String) -> (score: Double, ranges: [ResultRange])? {
        guard !pattern.isEmpty else { return nil }

        var candidateStringTokens = candidateString.split(whereSeparator: { $0.isWhitespace })
        var ranges = [ResultRange]()
        var lastRange: ResultRange?
        var score: Double = 0

        for searchToken in pattern {
            var matchedSearchToken = false

            for (candidateStringTokenIndex, candidateStringToken) in candidateStringTokens.enumerated() {
                if let range = candidateStringToken.range(of: searchToken, options: [.caseInsensitive, .diacriticInsensitive]),
                   range.lowerBound == candidateStringToken.startIndex {
                    matchedSearchToken = true
                    if let lastRange = lastRange {
                        // If next token range is behind last range
                        if range.lowerBound > lastRange.lowerBound {
                            score += 1.0 / Double(candidateString[lastRange.lowerBound...range.lowerBound].count)
                        } else {
                            score -= Double(candidateString[range.lowerBound...lastRange.lowerBound].count) / Double(candidateString.count)
                        }
                    }
                    ranges.append(range)
                    candidateStringTokens.remove(at: candidateStringTokenIndex)
                    lastRange = range
                    break
                }
            }

            guard matchedSearchToken else { return nil }
        }
        
        guard !ranges.isEmpty else { return nil }

        return (score, ranges)
    }
    
    func search(_ text: String, in aList: [String]) -> [SearchResult] {
        let pattern = createPattern(searchString: text)
        var results = [SearchResult]()
        
        aList.enumerated().forEach { (index, candidate) in
            if let result = self.matches(pattern, in: candidate) {
                results.append(SearchResult(index: index, score: result.score, ranges: result.ranges))
            }
        }
        return results
    }
    
    func search(_ text: String, in aList: [String], chunkSize: Int = 100, completion: @escaping ([SearchResult]) -> Void) {
        let pattern = createPattern(searchString: text)
        var items = [SearchResult]()
        
        // Serialize writes to `items`, for thread safety.
        // This label is non-unique but that should be fine as we don't expect
        // to need to debug work items running on this queue.
        let itemsQueue = DispatchQueue(label: "mespi.items.queue")
        
        let group = DispatchGroup()
        let count = aList.count
        
        stride(from: 0, to: count, by: chunkSize).forEach { offset in
            let chunk = Array(aList[offset..<min(offset + chunkSize, count)])
            group.enter()
            self.searchQueue.async {
                var chunkItems = [SearchResult]()
                
                for (index, item) in chunk.enumerated() {
                    if let result = self.matches(pattern, in: item) {
                        chunkItems.append(SearchResult(index: index + offset, score: result.score, ranges: result.ranges))
                    }
                }
                
                itemsQueue.async {
                    items.append(contentsOf: chunkItems)
                    group.leave()
                }
            }
        }
        
        group.notify(queue: self.searchQueue) {
            completion(items.sorted(by: { $0.score > $1.score }))
        }
    }
}
