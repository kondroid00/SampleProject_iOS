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
    static let ApiHost = "localhost:8080"
    
    static func getApiUrl() -> String {
        return ApiSchema + ApiHost
    }
    
}
