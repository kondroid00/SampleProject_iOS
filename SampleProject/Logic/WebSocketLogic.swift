//
//  WebSocketLogic.swift
//  SampleProject
//
//  Created by 近藤浩市郎 on 2017/10/11.
//  Copyright © 2017 Koichiro Kondo. All rights reserved.
//

import Foundation
import Starscream
import Unbox
import RxSwift

class WebSocketLogic {
    
    var socket: WebSocket?
    weak var delegate: WebSocketLogicDelegate?
    
    var clientId: Int?
    
    let disposeBag = DisposeBag()
    
    func connect(roomId: String) {
        socket = WebSocket(url: URL(string: NetworkConstants.getWebSocketUrl() + "/" + roomId)!)
        if let socket = socket {
            socket.delegate = self
            socket.connect()
        }
    }
    
    func disconnect() {
        socket?.disconnect()
    }
    
    func sendMessage(message: String) {
        guard let socket = socket else {
            return
        }
        let params: [String: Any] = [
            "clientId": clientId ?? 0,
            "message": message
        ]
        let data = try! JSONSerialization.data(withJSONObject: params, options: [])
        let json = ChatConstants.MsgPrefix.Message.rawValue + String(bytes: data, encoding: .utf8)!
        socket.write(string: json)
    }
    
}

extension WebSocketLogic: WebSocketDelegate {
    func websocketDidConnect(socket: WebSocketClient) {
        delegate?.websocketLogicDidConnect()
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        delegate?.websocketLogicDidDisconnect(error: error)
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        print(text)
        
        guard let prefix = ChatConstants.MsgPrefix(rawValue: text.substring(to: text.index(text.startIndex, offsetBy: 3))) else {
            return
        }
        
        
        let data = text.substring(from: text.index(text.startIndex, offsetBy: 3))
        print("data = \(data)")
        
        // jsonのパースを非同期で行う
        switch prefix {
        case .Joined:
            let start = Date()
            let observable: Observable<WebSocketActionDto> = Helper.parseObservable(jsonString: data)
            observable
                .subscribeOn(SerialDispatchQueueScheduler(qos: .userInitiated))
                .observeOn(MainScheduler.instance)
                .subscribe(
                    onNext: {[weak self](data) in
                        guard let weakSelf = self else {
                            return
                        }
                        weakSelf.delegate?.websocketLogicDidReceiveJoined(data: data)
                    }
                ).disposed(by: disposeBag)
            print(Date().timeIntervalSince(start))
        case .Removed:
            let observable: Observable<WebSocketActionDto> = Helper.parseObservable(jsonString: data)
            observable
                .subscribeOn(SerialDispatchQueueScheduler(qos: .userInitiated))
                .observeOn(MainScheduler.instance)
                .subscribe(
                    onNext: {[weak self](data) in
                        guard let weakSelf = self else {
                            return
                        }
                        weakSelf.delegate?.websocketLogicDidReceiveRemoved(data: data)
                    }
                ).disposed(by: disposeBag)

        case .Message:
            let observable: Observable<WebSocketMessageDto> = Helper.parseObservable(jsonString: data)
            observable
                .subscribeOn(SerialDispatchQueueScheduler(qos: .userInitiated))
                .observeOn(MainScheduler.instance)
                .subscribe(
                    onNext: {[weak self](data) in
                        guard let weakSelf = self else {
                            return
                        }
                        weakSelf.delegate?.websocketLogicDidReceiveMessage(data: data)
                    }
                ).disposed(by: disposeBag)
        }
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {}
}

protocol WebSocketLogicDelegate: class {
    func websocketLogicDidConnect() -> Void
    func websocketLogicDidDisconnect(error: Error?) -> Void
    func websocketLogicDidReceiveJoined(data: WebSocketActionDto) -> Void
    func websocketLogicDidReceiveRemoved(data: WebSocketActionDto) -> Void
    func websocketLogicDidReceiveMessage(data: WebSocketMessageDto) -> Void
}
