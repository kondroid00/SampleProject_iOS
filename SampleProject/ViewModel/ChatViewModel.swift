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
    let input: BehaviorSubject<String> = BehaviorSubject(value: "")
    
    func addMessage(_ data: WebSocketMessageDto) {
        do {
            var currentMessages = try messages.value()
            currentMessages.append(data)
            messages.onNext(currentMessages)
        } catch {
            
        }
    }
}
