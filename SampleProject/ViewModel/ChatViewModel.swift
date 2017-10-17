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
    private(set) var messageCount: Int = 0
    
    let input: BehaviorSubject<String> = BehaviorSubject(value: "")
    
    override init() {
        super.init()
        messages.subscribe(onNext: {[weak self] value in
            self?.messageCount = value.count
        }).disposed(by: disposeBag)
    }
    
    func addMessage(_ data: WebSocketMessageDto) {
        do {
            var currentMessages = try messages.value()
            currentMessages.append(data)
            messages.onNext(currentMessages)
        } catch {
            
        }
    }
}
