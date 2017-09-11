//
//  LoginResult.swift
//  SampleProject
//
//  Created by 近藤浩市郎 on 2017/09/10.
//  Copyright © 2017 Koichiro Kondo. All rights reserved.
//

import Foundation
import Unbox

struct LoginResult {
    let user: UserDto?
    let token: TokenDto?
}

extension LoginResult: Unboxable {
    init(unboxer: Unboxer) throws {
        self.user = try unboxer.unbox(key: "user")
        self.token = try unboxer.unbox(key: "token")
    }
}
