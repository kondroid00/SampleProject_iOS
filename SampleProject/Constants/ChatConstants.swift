//
//  ChatConstants.swift
//  SampleProject
//
//  Created by 近藤浩市郎 on 2017/10/11.
//  Copyright © 2017 Koichiro Kondo. All rights reserved.
//

import Foundation

struct ChatConstants {
    
    // メッセージを受けた時にどのDtoに変換するかどうかを決めるための識別子
    enum MsgPrefix: String {
        case Joined = "001"
        case Removed = "002"
        case Message = "003"
    }
}
