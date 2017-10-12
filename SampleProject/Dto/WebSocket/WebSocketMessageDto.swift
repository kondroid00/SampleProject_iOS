//
//  WebSocketMessageDto.swift
//  SampleProject
//
//  Created by 近藤浩市郎 on 2017/10/12.
//  Copyright © 2017 Koichiro Kondo. All rights reserved.
//

import Foundation
import Unbox

struct WebSocketMessageDto {
    let clientNo: Int
    let message: String
}

extension WebSocketMessageDto: Unboxable {
    init(unboxer: Unboxer) throws {
        self.clientNo = try unboxer.unbox(key: "clientNo")
        self.message = try unboxer.unbox(key: "message")
    }
}
