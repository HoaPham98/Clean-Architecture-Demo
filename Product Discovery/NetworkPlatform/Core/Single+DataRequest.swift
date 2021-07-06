//
//  Single+DataRequest.swift
//  NetworkModule
//
//  Created by Z on 12/12/19.
//  Copyright © 2019 Zen8Labs. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

//MARK: - Validation
//Support chaining validations
extension PrimitiveSequenceType where Element: DataRequest, Trait == SingleTrait {
    func validate(_ validation: @escaping DataRequest.Validation) -> Single<DataRequest> {
        return map { $0.validate(validation) }
    }
    
    func validate<S: Sequence>(statusCode acceptableStatusCodes: S) -> Single<DataRequest> where S.Iterator.Element == Int {
        return map { $0.validate(statusCode: acceptableStatusCodes) }
        
    }
    
    func validate<S: Sequence>(contentType acceptableContentTypes: S) -> Single<DataRequest> where S.Iterator.Element == String {
        return map { $0.validate(contentType: acceptableContentTypes) }
    }
}


//MARK: - Response serialization
/* Wraps alamofire response's result in a Single sequence with:
 - If response's result is .success -> emit data as a next event
 - If response's result is .failure -> emit an error event
 */
extension PrimitiveSequenceType where Element: DataRequest, Trait == SingleTrait {
    func responseDecodable<T: Decodable>(of type: T.Type = T.self,
                                         keyPath: String,
                                         decoder: JSONDecoder = JSONDecoder(),
                                         jsonReadingOptions: JSONSerialization.ReadingOptions = .allowFragments,
                                         useCache: Bool = false) -> Single<T> {

        return responseDecodable(of: type, decoder: NestedJSONDecoder(keyPath: keyPath, decoder: decoder, readingOptions: jsonReadingOptions), useCache: useCache)
    }
    
    func responseDecodable<T: Decodable>(of type: T.Type = T.self, decoder: DataDecoder = JSONDecoder(), useCache: Bool) -> Single<T> {
        return flatMap { (request) -> Single<T> in
            return Single.create { (single) -> Disposable in
                let request = request.responseData(completionHandler: { (response) in
                    var cachedData: Data?
                    if useCache {
                        if let urlRequest = request.request,
                           let cached = networkCache.cachedResponse(for: urlRequest) {
                            cachedData = cached.data
                        }
                    }
                    guard (response.error == nil || cachedData != nil) else {
                        single(.failure(response.error!.asDomainError()))
                        return
                    }
                    
                    if response.data != nil {
                        cachedData = response.data
                    }

                    guard let responseData = cachedData else {
                        single(.failure(NetworkError.responseSerializationFailed(reason: .nilDataAtKeyPath(keyPath: ""))))
                        return
                    }

                    do {
                        let item = try decoder.decode(T.self, from: responseData)
                        single(.success(item))
                    } catch {
                        single(.failure(DemoAPIError.unknownError(error)))
                    }
                }, autoClearCache: true)
                request.resume()
                return Disposables.create {
                    request.cancel()
                }
            }
        }
    }
    
    func responseData() -> Single<Data> {
        return flatMap { (request) -> Single<Data> in
            return Single.create { (single) -> Disposable in
                let request = request.responseData { (response) in
                    switch response.result {
                    case .success(let value):
                        single(.success(value))
                    case .failure(let error):
                        single(.failure(error))
                    }
                }
                request.resume()
                return Disposables.create {
                    request.cancel()
                }
            }
        }
    }
    
    func responseJSON(options: JSONSerialization.ReadingOptions = .allowFragments) -> Single<Any> {
        return flatMap { (request) -> Single<Any> in
            return Single.create { (single) -> Disposable in
                let request = request.responseJSON(options: options) { (response) in
                    switch response.result {
                    case .success(let value):
                        single(.success(value))
                    case .failure(let error):
                        single(.failure(error))
                    }
                }
                request.resume()
                return Disposables.create {
                    request.cancel()
                }
            }
        }
    }
    
    func responseString(encoding: String.Encoding? = nil) -> Single<String> {
        return flatMap { (request) -> Single<String> in
            return Single.create { (single) -> Disposable in
                let request = request.responseString(encoding: encoding) { (response) in
                    switch response.result {
                    case .success(let value):
                        single(.success(value))
                    case .failure(let error):
                        single(.failure(error))
                    }
                }
                request.resume()
                return Disposables.create {
                    request.cancel()
                }
            }
        }
    }
    
    func responseCompletable() -> Completable {
        responseData().asCompletable()
    }
}
//MARK: - Debugging
extension PrimitiveSequenceType where Trait == SingleTrait, Element: DataRequest {
    func debugString(encoding: String.Encoding? = nil, debugClosure: @escaping (AFDataResponse<String>) -> Void) -> Single<DataRequest> {
        return map { $0.responseString(encoding: encoding, completionHandler: debugClosure) }
    }
    
    func debugJSON(options: JSONSerialization.ReadingOptions = .allowFragments, debugClosure: @escaping (AFDataResponse<Any>) -> Void) -> Single<DataRequest> {
        return map { $0.responseJSON(options: options, completionHandler: debugClosure) }
    }
    
    func debugData(_ debugClosure: @escaping (AFDataResponse<Data>) -> Void) -> Single<DataRequest> {
        return map { $0.responseData(completionHandler: debugClosure) }
    }
    
//    func debugDecodable<T: Decodable>(of type: T.Type = T.self, decoder: DataDecoder = JSONDecoder(), debugClosure: @escaping (DataResponse<T>) -> Void) -> Single<DataRequest> {
//        return map { $0.responseDecodable(of: type, decoder: decoder, completionHandler: debugClosure) }
//    }
}
