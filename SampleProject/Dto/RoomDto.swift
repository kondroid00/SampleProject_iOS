//
//  RoomDto.swift
//  SampleProject
//
//  Created by 近藤浩市郎 on 2017/09/12.
//  Copyright © 2017 Koichiro Kondo. All rights reserved.
//

import Foundation
import Unbox

struct RoomDto {
    let id: String?
    let name: String?
    let theme: String?
}

extension RoomDto: Unboxable {
    init(unboxer: Unboxer) throws {
        self.id = try unboxer.unbox(key: "id")
        self.name = try unboxer.unbox(key: "name")
        self.theme = try unboxer.unbox(key: "theme")
    }
}
