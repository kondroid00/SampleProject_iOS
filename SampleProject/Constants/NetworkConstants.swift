//
//  NetworkConstants.swift
//  SampleProject
//
//  Created by 近藤浩市郎 on 2017/09/04.
//  Copyright © 2017 Koichiro Kondo. All rights reserved.
//

import Foundation

struct NetworkConstants {
    
    static let ApiSchema = "http://"
    static let ApiHost = "192.168.100.6:8080"
    
    static let WebSocketSchema = "ws://"
    static let WebSocketHost = "192.168.100.6:1323"
    
    static func getApiUrl() -> String {
        return ApiSchema + ApiHost
    }
    
    static func getWebSocketUrl() -> String {
        return WebSocketSchema + WebSocketHost
    }
}
