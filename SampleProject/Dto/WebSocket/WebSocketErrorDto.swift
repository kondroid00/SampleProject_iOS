//
//  WebSocketErrorDto.swift
//  SampleProject
//
//  Created by 近藤浩市郎 on 2017/10/13.
//  Copyright © 2017 Koichiro Kondo. All rights reserved.
//

import Foundation
import Unbox

struct WebSocketErrorDto {
    let errorCode: Int
    let message: String
}

extension WebSocketErrorDto: Unboxable {
    init(unboxer: Unboxer) throws {
        self.errorCode = try unboxer.unbox(key: "errorCode")
        self.message = try unboxer.unbox(key: "message")
    }
}
