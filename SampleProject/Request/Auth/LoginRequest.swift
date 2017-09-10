//
//  LoginRequest.swift
//  SampleProject
//
//  Created by 近藤浩市郎 on 2017/09/10.
//  Copyright © 2017 Koichiro Kondo. All rights reserved.
//

import Foundation

class LoginRequest : BaseRequest {
    
    class Params {
        var userId: String?
    }
    
    init() {
        let path = "/login"
        super.init(path: path)
    }
}
