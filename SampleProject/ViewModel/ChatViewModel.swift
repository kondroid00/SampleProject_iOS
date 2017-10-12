//
//  ChatViewModel.swift
//  SampleProject
//
//  Created by 近藤浩市郎 on 2017/10/10.
//  Copyright © 2017 Koichiro Kondo. All rights reserved.
//

import Foundation
import RxSwift

class ChatViewModel: BaseViewModel {
    let messages: BehaviorSubject<[WebSocketMessageDto]> = BehaviorSubject(value: [])
    
    
    
}
