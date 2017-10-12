//
//  WebSocketActionDto.swift
//  SampleProject
//
//  Created by 近藤浩市郎 on 2017/10/12.
//  Copyright © 2017 Koichiro Kondo. All rights reserved.
//

import Foundation
import Unbox

struct WebSocketActionDto {

    let clients: [Client]
    
    struct Client {
        let clientNo: Int
        let name: String?
        let action: Bool
        let selfFlag: Bool
    }
}

extension WebSocketActionDto: Unboxable {
    init(unboxer: Unboxer) throws {
        self.clients = try unboxer.unbox(key: "clients")
    }
}

extension WebSocketActionDto.Client: Unboxable {
    init(unboxer: Unboxer) throws {
        self.clientNo = try unboxer.unbox(key: "clientNo")
        self.name = try unboxer.unbox(key: "name")
        self.action = try unboxer.unbox(key: "action")
        self.selfFlag = try unboxer.unbox(key: "self")
    }
}
