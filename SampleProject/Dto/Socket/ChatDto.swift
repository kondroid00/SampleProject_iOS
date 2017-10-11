//
//  ChatDto.swift
//  SampleProject
//
//  Created by 近藤浩市郎 on 2017/10/11.
//  Copyright © 2017 Koichiro Kondo. All rights reserved.
//

import Foundation
import Unbox

struct ChatDto {
    let clientId: Int
    let message: MessageDto
    
    struct MessageDto {
        let name: String
        let message: String
    }
}

extension ChatDto: Unboxable {
    init(unboxer: Unboxer) throws {
        self.clientId = try unboxer.unbox(key: "clientId")
        self.message = try unboxer.unbox(key: "message")
    }
}

extension ChatDto.MessageDto: Unboxable {
    init(unboxer: Unboxer) throws {
        self.name = try unboxer.unbox(key: "clientId")
        self.message = try unboxer.unbox(key: "message")
    }
}
