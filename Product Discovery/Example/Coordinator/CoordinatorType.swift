//
//  CoordinatorType.swift
//  Demo Demo
//
//  Created by HoaPQ on 4/24/21.
//

import Foundation
import RxSwift

//MARK:- Base Coordinator

protocol CoordinatorType {
    associatedtype Base: UIViewController
    var base: Base? { get }
}

struct Coordinator<Base: UIViewController>: CoordinatorType {
    weak var base: Base?
    init(base: Base?) {
        self.base = base
    }
}

protocol CoordinatorCompatible {
    associatedtype Base: UIViewController
    var coordinator: Coordinator<Base> { get }
}

extension CoordinatorCompatible where Self: UIViewController {
    var coordinator: Coordinator<Self> {
        return Coordinator(base: self)
    }
}

extension UIViewController: CoordinatorCompatible {
    typealias Base = UIViewController
}

//MARK:- Default implementation
extension CoordinatorType {
    func navigate(_ navigation: @escaping () -> Void) -> Completable {
        return Completable.create { (callback) -> Disposable in
            navigation()
            callback(.completed)
            return Disposables.create()
        }
    }
    
    func push(_ controller: @escaping () -> UIViewController, animated: Bool = true) -> Completable {
        navigate {
            self.base?.navigationController?.pushViewController(controller(), animated: animated)
        }
    }
    
    func present(_ controller: @escaping () -> UIViewController, animated: Bool = true, completion: (() -> Void)? = nil) -> Completable {
        navigate {
            self.base?.present(controller(), animated: animated, completion: completion)
        }
    }
    
    func back(animated: Bool = true) -> Completable {
        return navigate {
            self.base?.navigationController?.popViewController(animated: animated)
        }
    }
    
    func popToRoot(animated: Bool = true) -> Completable {
        return navigate {
            self.base?.navigationController?.popToRootViewController(animated: animated)
        }
    }
    
    func dismiss(animated: Bool = true, completion: (()->Void)? = nil) -> Completable {
        return navigate {
             self.base?.dismiss(animated: animated, completion: completion)
        }
    }
    
    func share(items: [Any], sourceView: Any?, animated: Bool = true, completion: (()->Void)? = nil) -> Completable {
        navigate {
            let activityVc = UIActivityViewController(activityItems: items, applicationActivities: nil)
            activityVc.popoverPresentationController?.sourceView = (sourceView as? UIView)
            self.base?.present(activityVc, animated: animated, completion: completion)
        }
    }
}

extension CoordinatorType {
    func showMessage(title: String? = nil, message: String?, completion: (() -> Void)? = nil) -> Completable {
        let vc = UIAlertController(title: title, message: message, preferredStyle: .alert)
        vc.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action) in
            completion?()
        }))
        
        return present { vc }
    }
}
