//
//  LoadingHUD.swift
//  Demo Demo
//
//  Created by HoaPQ on 4/25/21.
//

import UIKit
import RxSwift
import RxCocoa
import MBProgressHUD

class LoadingHUD {
    static func loadingBinder(for controller: UIViewController) -> Binder<Bool> {
        return Binder<Bool>(controller) { (target, isLoading) in
            if isLoading {
                MBProgressHUD.showAdded(to: controller.view, animated: true)
            } else {
                MBProgressHUD.hide(for: controller.view, animated: true)
            }
        }
    }
}
