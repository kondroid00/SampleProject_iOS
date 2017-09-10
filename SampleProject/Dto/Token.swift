//
//  Token.swift
//  SampleProject
//
//  Created by 近藤浩市郎 on 2017/09/10.
//  Copyright © 2017 Koichiro Kondo. All rights reserved.
//

import Foundation
import Unbox

struct Token {
    let token: String?
    let expiredAt: Int64?
}

extension Token: Unboxable {
    init(unboxer: Unboxer) throws {
        self.token = try unboxer.unbox(key: "token")
        self.expiredAt = try unboxer.unbox(key: "expiredAt")
    }
}
