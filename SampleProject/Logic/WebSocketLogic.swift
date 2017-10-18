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
import Wrap

class WebSocketLogic {
    enum State {
        case Opening
        case Opened
        case Closed
    }
    
    // State
    fileprivate(set) var state = State.Closed
    
    // Starscream
    private var socket: WebSocket?
    weak var delegate: WebSocketLogicDelegate?
    
    // ClientData
    private var clientNo: Int?
    private var name: String?
    
    // PingPong
    private static let PingPongInterval: UInt64 = 5 // ５秒間Pongが帰ってこなかったら切断
    fileprivate var pongReceiveTime: Int64? // 最後にPongを受け取った時間
    private var timer: Timer?
    
    let disposeBag = DisposeBag()
    
    func connect(roomId: String) {
        socket = WebSocket(url: URL(string: NetworkConstants.getWebSocketUrl() + "/" + roomId)!)
        if let socket = socket {
            socket.delegate = self
            socket.pongDelegate = self
            socket.connect()
            state = .Opening
        }
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) {[weak self] timer in
            self?.checkPingPong()
        }
    }
    
    func disconnect() {
        state = .Closed
        socket?.disconnect()
        timer?.invalidate()
    }
    
    func isSelf(data: WebSocketMessageDto) -> ChatConstants.ChatMsgOwner {
        if let logicClientNo = clientNo {
            return logicClientNo == data.clientNo ? .MySelf : .Other
        }
        return .Unknown
    }
    
    fileprivate func write(prefix: ChatConstants.MsgPrefix, params: [String: Any]) {
        let data = try! JSONSerialization.data(withJSONObject: params, options: [])
        let json = prefix.rawValue + String(bytes: data, encoding: .utf8)!
        socket?.write(string: json)
    }
    
    //-------------------------------------------------------------------------------------------
    //  Send
    //-------------------------------------------------------------------------------------------
    func sendJoin(user: UserDto) {
        let params: [String: Any] = [
            "name": user.name,
            "userId": user.id
        ]
        write(prefix: .Joined, params: params)
    }
    
    func sendMessage(message: String) {
        guard let clientNo = clientNo, let name = name else {
            return
        }
        
        let data = WebSocketMessageDto(clientNo: clientNo,
                                       name: name,
                                       message: message)
        
        var params: [String: Any] = [:]
        do {
            params = try wrap(data)
        } catch {
            return
        }
        
        write(prefix: .Message, params: params)
    }
    
    //-------------------------------------------------------------------------------------------
    //  Receive
    //-------------------------------------------------------------------------------------------
    fileprivate func receiveJoined(data: WebSocketActionDto) {
        if clientNo == nil || name == nil {
            for client in data.clients {
                if(client.selfFlag) {
                    clientNo = client.clientNo
                    name = client.name
                }
            }
        }
        delegate?.websocketLogicDidReceiveJoined(data: data)
    }
    
    fileprivate func receiveRemoved(data: WebSocketActionDto) {
        delegate?.websocketLogicDidReceiveRemoved(data: data)
    }
    
    fileprivate func receiveMessage(data: WebSocketMessageDto) {
        delegate?.websocketLogicDidReceiveMessage(data: data)
    }
    
    fileprivate func receiveError(data: WebSocketErrorDto) {
        delegate?.websocketLogicDidReceiveError(data: data)
    }
    
    //-------------------------------------------------------------------------------------------
    //  PingPong
    //-------------------------------------------------------------------------------------------
    func checkPingPong() {
        // Ping送信
        socket?.write(ping: Data())
        
        // Pongが帰ってきてるかチェック
        if let pongReceiveTime = pongReceiveTime {
            let diff = Date().toSeconds() - pongReceiveTime
            if diff > WebSocketLogic.PingPongInterval {
                delegate?.websocketLogicDidDisconnect(error: WebSocketError.ConnectionFailed(description: "接続が切れました"))
                disconnect()
            }
        }
    }
}

extension WebSocketLogic: WebSocketDelegate {
    func websocketDidConnect(socket: WebSocketClient) {
        state = .Opened
        delegate?.websocketLogicDidConnect()
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        switch state {
        case .Opening:
            delegate?.websocketLogicDidFailed(error: WebSocketError.ConnectDidFailed(description: "接続に失敗しました。"))
        case .Opened:
            delegate?.websocketLogicDidDisconnect(error: WebSocketError.ConnectionFailed(description: "接続が切れました"))
        case .Closed:
            return
        }
        
        state = .Closed
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
            let observable: Observable<WebSocketActionDto> = Helper.parseObservable(jsonString: data)
            observable
                .subscribeOn(SerialDispatchQueueScheduler(qos: .userInitiated))
                .observeOn(MainScheduler.instance)
                .subscribe(
                    onNext: {[weak self](data) in
                        self?.receiveJoined(data: data)
                    }
                ).disposed(by: disposeBag)
        case .Removed:
            let observable: Observable<WebSocketActionDto> = Helper.parseObservable(jsonString: data)
            observable
                .subscribeOn(SerialDispatchQueueScheduler(qos: .userInitiated))
                .observeOn(MainScheduler.instance)
                .subscribe(
                    onNext: {[weak self](data) in
                        self?.receiveRemoved(data: data)
                    }
                ).disposed(by: disposeBag)

        case .Message:
            let observable: Observable<WebSocketMessageDto> = Helper.parseObservable(jsonString: data)
            observable
                .subscribeOn(SerialDispatchQueueScheduler(qos: .userInitiated))
                .observeOn(MainScheduler.instance)
                .subscribe(
                    onNext: {[weak self](data) in
                        self?.receiveMessage(data: data)
                    }
                ).disposed(by: disposeBag)
            
        case .Error:
            let observable: Observable<WebSocketErrorDto> = Helper.parseObservable(jsonString: data)
            observable
                .subscribeOn(SerialDispatchQueueScheduler(qos: .userInitiated))
                .observeOn(MainScheduler.instance)
                .subscribe(
                    onNext: {[weak self](data) in
                        self?.receiveError(data: data)
                    }
                ).disposed(by: disposeBag)
        }
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {}
}

extension WebSocketLogic: WebSocketPongDelegate {
    func websocketDidReceivePong(socket: WebSocketClient, data: Data?) {
        self.pongReceiveTime = Date().toSeconds()
    }
}

protocol WebSocketLogicDelegate: class {
    func websocketLogicDidConnect() -> Void
    func websocketLogicDidDisconnect(error: Error?) -> Void
    func websocketLogicDidFailed(error: Error) -> Void
    func websocketLogicDidReceiveJoined(data: WebSocketActionDto) -> Void
    func websocketLogicDidReceiveRemoved(data: WebSocketActionDto) -> Void
    func websocketLogicDidReceiveMessage(data: WebSocketMessageDto) -> Void
    func websocketLogicDidReceiveError(data: WebSocketErrorDto) -> Void
}
