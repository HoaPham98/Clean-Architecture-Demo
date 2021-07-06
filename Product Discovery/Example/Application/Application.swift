//
//  Application.swift
//  Demo Demo
//
//  Created by HoaPQ on 4/24/21.
//

import Foundation
import Domain
import NetworkPlatform

class Application {
    static let shared = Application()
    
    let network = Network(baseURL: URL(string: "https://run.mocky.io")!)
    
    private init() {}
}
