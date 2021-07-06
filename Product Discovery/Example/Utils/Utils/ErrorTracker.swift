//
//  ErrorTracker.swift
//  onevinmec
//
//  Created by Z on 12/12/19.
//  Copyright © 2019 Zen8Labs. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Domain

final public class ErrorTracker {
    private let _subject = PublishSubject<Error>()
    
    func asDriver() -> Driver<Error> {
        return _subject.asDriver(onErrorDriveWith: Driver.empty())
    }
    
    func asObservable() -> Observable<Error> {
        return _subject.asObservable().observeOn(MainScheduler.instance)
    }
    
    private func onError(_ error: Error) {
        _subject.onNext(error)
    }
    
    deinit {
        _subject.onCompleted()
    }
}

extension ErrorTracker: DomainConvertible {
    public func asDomain() -> Observable<DemoError> {
        //We don't want to show error message for .reCaptchaCancelled error
        return self.asObservable().compactMap { $0.asDemoError() }
    }
}

// MARK: - ErrorTracker + ObservableType
extension ErrorTracker {
    fileprivate func trackError<O: ObservableType>(from source: O) -> Observable<O.Element> {
        return source.do(onError: onError)
    }
}

// MARK: - ErrorTracker + PrimitiveSequence
//Single
extension ErrorTracker {
    fileprivate func trackError<E>(from source: Single<E>) -> Single<E> {
        return source.do(onError: onError)
    }
}
//Completable
extension ErrorTracker {
    fileprivate func trackError(from source: Completable) -> Completable {
        return source.do(onError: onError)
    }
}
//Maybe
extension ErrorTracker {
    fileprivate func trackError<E>(from source: Maybe<E>) -> Maybe<E> {
        return source.do(onError: onError)
    }
}

// MARK: - Operators
extension ObservableType {
    func trackError(with tracker: ErrorTracker) -> Observable<Element> {
        return tracker.trackError(from: self)
    }
}

extension PrimitiveSequenceType where Trait == SingleTrait {
    func trackError(_ tracker: ErrorTracker) -> Single<Element> {
        return tracker.trackError(from: self.primitiveSequence)
    }
}

extension PrimitiveSequenceType where Trait == CompletableTrait, Element == Never {
    func trackError(_ tracker: ErrorTracker) -> Completable {
        return tracker.trackError(from: self.primitiveSequence)
    }
}

extension PrimitiveSequenceType where Trait == MaybeTrait {
    func trackError(_ tracker: ErrorTracker) -> Maybe<Element> {
        return tracker.trackError(from: self.primitiveSequence)
    }
}

