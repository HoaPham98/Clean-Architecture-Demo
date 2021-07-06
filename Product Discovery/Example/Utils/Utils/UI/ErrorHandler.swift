//
//  ErrorHandler.swift
//  Product Discovery
//
//  Created by HoaPQ on 4/26/21.
//

import UIKit
import Domain
import RxSwift
import RxCocoa

class ErrorHandler {
    static func defaultAlertBinder(title: String? = nil, controller: UIViewController) -> Binder<DemoError> {
        return Binder(controller) { target, error in
            let alertVC = UIAlertController(title: title, message: error.localizedDescription, preferredStyle: .alert)
            if #available(iOS 13.0, *) {
                alertVC.overrideUserInterfaceStyle = .light
            } else {
                // Fallback on earlier versions
            }
            alertVC.addAction(UIAlertAction(title: "Đóng", style: .cancel, handler: nil))
            target.present(alertVC, animated: true, completion: nil)
        }
    }
}

extension DemoError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .noInternet:
            return "Không có internet, vui lòng kiểm tra lại"
        case .httpError:
            return "Hệ thống đang gặp sự cố, vui lòng thử lại sau"
        case .other(error: let error):
            return error.localizedDescription
        }
    }
}
