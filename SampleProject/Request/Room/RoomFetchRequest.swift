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
        let rooms: ([RoomDto])?
        
        init(unboxer: Unboxer) throws {
            self.rooms = try unboxer.unbox(key: "rooms")
        }
    }
    
    init() {
        let path = "/room"
        super.init(path: path)
    }
}

