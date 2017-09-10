//
//  UserCreateRequest.swift
//  SampleProject
//
//  Created by 近藤浩市郎 on 2017/09/10.
//  Copyright © 2017 Koichiro Kondo. All rights reserved.
//

import Foundation

class UserCreateRequest : BaseRequest {
    
    class Params {
        var name: String?
    }
    
    init() {
        let path = "/user/create"
        super.init(path: path)
    }
}
