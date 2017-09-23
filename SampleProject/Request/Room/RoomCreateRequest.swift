//
//  RoomCreateRequest.swift
//  SampleProject
//
//  Created by 近藤浩市郎 on 2017/09/22.
//  Copyright © 2017 Koichiro Kondo. All rights reserved.
//

import Foundation
import Unbox

class RoomCreateRequest : BaseRequest {
    
    class Params: BaseRequest.BaseAuthParams {
        var name: String?
        var theme: String?
    }
    
    struct Result: Unboxable {
        let room: RoomDto?
        
        init(unboxer: Unboxer) throws {
            self.room = try unboxer.unbox(key: "room")
        }
    }
    
    init() {
        let path = "/room/create"
        super.init(path: path)
    }
}
