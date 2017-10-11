//
//  WebSocketLogic.swift
//  SampleProject
//
//  Created by 近藤浩市郎 on 2017/10/11.
//  Copyright © 2017 Koichiro Kondo. All rights reserved.
//

import Foundation
import Starscream

class WebSocketLogic {
    
    var socket: WebSocket?
    weak var delegate: WebSocketLogicDelegate?
    
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
        socket?.write(string: message)
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
        delegate?.websocketLogicDidReceiveMessage(text: text)
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {}
}

protocol WebSocketLogicDelegate: class {
    func websocketLogicDidConnect() -> Void
    func websocketLogicDidDisconnect(error: Error?) -> Void
    func websocketLogicDidReceiveMessage(text: String) -> Void
}
