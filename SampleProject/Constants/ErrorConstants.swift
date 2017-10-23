//
//  ErrorConstants.swift
//  SampleProject
//
//  Created by 近藤浩市郎 on 2017/10/12.
//  Copyright © 2017 Koichiro Kondo. All rights reserved.
//

import Foundation

enum OptionalError: Error {
    case UnwrapFailed
}

enum WebSocketError: Error {
    case ConnectDidFailed(description: String)
    case ConnectingFailed(description: String)
}
