//
//  RoomFetchRequest.swift
//  SampleProject
//
//  Created by 近藤浩市郎 on 2017/09/16.
//  Copyright © 2017 Koichiro Kondo. All rights reserved.
//

import Foundation
import Unbox

class RoomFetchRequest : BaseRequest {

    class Params {
        var name: String?
        var theme: String?
    }
    
    struct Result: Unboxable {
        let user: UserDto?
        let token: TokenDto?
        
        init(unboxer: Unboxer) throws {
            self.user = try unboxer.unbox(key: "user")
            self.token = try unboxer.unbox(key: "token")
        }
    }
    
    init() {
        let path = "/user"
        super.init(path: path)
    }
}

