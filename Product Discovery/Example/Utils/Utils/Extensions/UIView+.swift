//
//  UIView+.swift
//  Demo Demo
//
//  Created by HoaPQ on 4/25/21.
//

import UIKit
import SnapKit

extension UIView {
    var safeArea: ConstraintBasicAttributesDSL {
        return safeAreaLayoutGuide.snp
    }
}

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach {
            self.addSubview($0)
        }
    }
    
    func addTapGesture(_ target: Any, action: Selector) {
        let tapGesture = UITapGestureRecognizer()
        tapGesture.addTarget(target, action: action)
        addGestureRecognizer(tapGesture)
        isUserInteractionEnabled = true
    }
}
