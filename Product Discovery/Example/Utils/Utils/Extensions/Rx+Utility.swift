//
//  Rx+Utility.swift
//  Domain
//
//  Created by HoaPQ on 4/24/21.
//

import Foundation
import RxSwift
import RxCocoa

extension ObservableType {
    func compactMap<R>(_ transform: @escaping (Self.Element) throws -> R?) -> RxSwift.Observable<R> {
        return self.map { try? transform($0) }.filter { $0 != nil }.map { $0! }
    }
}

public extension ObservableType {
    func asDriverOnErrorJustComplete() -> Driver<Element> {
        return asDriver(onErrorDriveWith: Driver.empty())
    }
    
    func mapToVoid() -> Observable<Void> {
        return map { _ in }
    }
    
    func ignoreNil<Wrapped>() -> Observable<Wrapped> where Element == Optional<Wrapped> {
        return flatMap { (element) -> Observable<Wrapped> in
            switch element {
            case .some(let value):
                return Observable.just(value)
            case .none:
                return Observable.empty()
            }
        }
    }
}

public extension BehaviorSubject {
    
    var elementValue: Element? {
        do {
            return try self.value()
        } catch {
            return nil
        }
    }
}

public extension ObservableConvertibleType {
    func catchErrorJustComplete() -> Observable<Element> {
        return self.asObservable().catch{ _ in Observable.empty() }
    }
}

