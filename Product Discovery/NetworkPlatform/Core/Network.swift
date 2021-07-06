//
//  Network.swift
//  NetworkPlatform
//
//  Created by HoaPQ on 4/24/21.
//

import Foundation
import Alamofire

fileprivate let memoryCapacity = 100 * 1024 * 1024; // 100 MB
fileprivate let diskCapacity = 100 * 1024 * 1024; // 100 MB
let networkCache = URLCache(memoryCapacity: memoryCapacity, diskCapacity: diskCapacity, diskPath: "shared_cache")

public class Network {
    var configuration: NetworkConfiguration
    var afSession: Session
    
    public init(baseURL: URL) {
        configuration = NetworkConfiguration(baseURL: baseURL)
        let configuration = URLSessionConfiguration.default
        configuration.urlCache = networkCache
        afSession = Session(configuration: configuration)
    }
}
