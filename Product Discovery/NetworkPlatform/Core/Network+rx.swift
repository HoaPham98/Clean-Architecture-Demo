//
//  Network+rx.swift
//  NetworkPlatform
//
//  Created by HoaPQ on 4/24/21.
//

import Foundation
import Alamofire
import AlamofireURLCache5
import RxSwift

struct RequestConverter: URLRequestConvertible {
    let configuration: NetworkConfiguration
    let endpoint: EndpointConvertible
    
    func asURLRequest() throws -> URLRequest {
        try endpoint.asURLRequest(configuration: configuration)
    }
}

extension Network: ReactiveCompatible {}
extension Reactive where Base: Network {
    func request(_ endpoint: EndpointConvertible, shouldCache: Bool = false) -> Single<DataRequest> {
        return self.base.afSession.rx.request(RequestConverter(configuration: base.configuration, endpoint: endpoint), shouldCache: shouldCache).debugString { (response) in
//            #if DEBUG
//            print("-------------->")
//            print(response.debugDescription)
//            print("<--------------")
//            #endif
        }
    }
}

extension Session: ReactiveCompatible {}
extension Reactive where Base == Session {
    func request(_ request: URLRequestConvertible, shouldCache: Bool) -> Single<DataRequest> {
        return Single.create { [afSession = self.base](callback) -> Disposable in
            // max-age: 1 year
            let age = shouldCache ? 31536000 : -1
            callback(.success(afSession.request(request).cache(maxAge: age)))
            return Disposables.create()
        }
    }
}
