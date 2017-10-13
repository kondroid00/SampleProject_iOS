//
//  ChatViewController.swift
//  SampleProject
//
//  Created by 近藤浩市郎 on 2017/10/10.
//  Copyright © 2017 Koichiro Kondo. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ChatViewController: BaseTFViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    fileprivate let vm = ChatViewModel()
    private let dataSource = ChatDataSource()
    
    fileprivate let webSocketLogic = WebSocketLogic()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sendButton.rx.tap.subscribe(onNext: {[weak self] in
            guard let weakSelf = self else {
                return
            }
            weakSelf.tapSendButton()
        }).addDisposableTo(disposeBag)

        vm.messages
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .addDisposableTo(disposeBag)
        
        tableView.delegate = self
        
        webSocketLogic.delegate = self
        
        webSocketLogic.connect(roomId: "test")
    
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        webSocketLogic.disconnect()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    private func tapSendButton() {
        webSocketLogic.sendMessage(message: "test")
    }
   
    

}


//---------------------------------------------------------------------------
//  TableView
//---------------------------------------------------------------------------
extension ChatViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return view.frame.height * 0.10
    }
}

class ChatDataSource: NSObject, UITableViewDataSource, RxTableViewDataSourceType {
    
    typealias Element = [WebSocketMessageDto]
    
    var items: Element = []
    
    func tableView(_ tableView: UITableView, observedEvent: Event<Element>) -> Void {
        if case .next(let items) = observedEvent {
            self.items = items
            tableView.reloadData()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(cellType: RoomsTableViewCell.self, for: indexPath)
        //cell.setData(items[indexPath.row])
        return cell
    }
}

//---------------------------------------------------------------------------
//  WebSocket
//---------------------------------------------------------------------------
extension ChatViewController: WebSocketLogicDelegate {

    func websocketLogicDidConnect() {
        if let user = AccountManager.instance.user {
            webSocketLogic.sendJoin(user: user)
        }
    }
    
    func websocketLogicDidDisconnect(error: Error?) {
        
    }
    
    func websocketLogicDidReceiveJoined(data: WebSocketActionDto) {
        
    }
    
    func websocketLogicDidReceiveRemoved(data: WebSocketActionDto) {
        
    }
    
    func websocketLogicDidReceiveMessage(data: WebSocketMessageDto) {

    }
    
    func websocketLogicDidReceiveError(data: WebSocketErrorDto) {
        
    }
}






