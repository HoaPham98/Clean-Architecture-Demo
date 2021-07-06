//
//  DemoValidation.swift
//  NetworkPlatform
//
//  Created by HoaPQ on 4/24/21.
//

import Foundation
import RxSwift
import Alamofire

extension PrimitiveSequenceType where Element: DataRequest, Trait == SingleTrait {
    func validateDemo(acceptableStatusCodes: [Int] = Array(200..<300)) -> Single<DataRequest> {
        return self.validate { (request, response, data) -> DataRequest.ValidationResult in
            if acceptableStatusCodes.contains(response.statusCode) {
                return .success(())
            }
            
            return .failure(DemoAPIError.httpError(statusCode: response.statusCode))
        }
    }
}
