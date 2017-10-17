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
    @IBOutlet weak var inputTextView: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var inputTextViewHeight: NSLayoutConstraint!
    var lastInputHeight: CGFloat?
    
    fileprivate let vm = ChatViewModel()
    private let dataSource = ChatDataSource()
    
    fileprivate let webSocketLogic = WebSocketLogic()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerNib(ChatOutgoingTableViewCell.self)
        tableView.registerNib(ChatIncomingTableViewCell.self)
        
        sendButton.rx.tap.subscribe(onNext: {[weak self] in
            guard let weakSelf = self else {
                return
            }
            weakSelf.tapSendButton()
        }).disposed(by: disposeBag)
        
        dataSource.webSocketLogic = webSocketLogic

        vm.messages
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        inputTextView.rx.text.orEmpty.subscribe(onNext: {[weak self](text) in
            guard let weakSelf = self else {
                return
            }
            weakSelf.adjustInputHeight()
            weakSelf.vm.input.onNext(text)
        }).disposed(by: disposeBag)

        
        tableView.delegate = self
        
        inputTextView.delegate = self
        
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
        do {
            let message = try vm.input.value()
            if message.count > 0 {
                webSocketLogic.sendMessage(message: message)
                inputTextView.text = nil
                view.endEditing(true)
            }
        } catch  {
            
        }
    }
    

    private func adjustInputHeight() {
        let size:CGSize = inputTextView.sizeThatFits(inputTextView.frame.size)
        if lastInputHeight != size.height {
            lastInputHeight = size.height
            inputTextViewHeight.constant = size.height
            ChatViewController.focusLastCell(tableView: tableView, lastRow: vm.messageCount, animated: false)
        }
    }
    
    // 最新アイテムにスクロール
    fileprivate static func focusLastCell(tableView: UITableView?, lastRow: Int, animated: Bool = true) {
        if lastRow > 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                tableView?.scrollToRow(at: IndexPath(row: lastRow - 1, section: 0), at: .bottom, animated: animated)
            }
        }
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
    weak var webSocketLogic: WebSocketLogic?
    
    var items: Element = []
    
    func tableView(_ tableView: UITableView, observedEvent: Event<Element>) -> Void {
        if case .next(let items) = observedEvent {
            self.items = items
            tableView.reloadData()
            ChatViewController.focusLastCell(tableView: tableView, lastRow: items.count)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = items[indexPath.row]
        let owner = webSocketLogic != nil ? webSocketLogic!.isSelf(data: data) : .Unknown
        switch owner {
        case .MySelf:
            let cell = tableView.dequeueReusableCell(cellType: ChatOutgoingTableViewCell.self, for: indexPath) as! ChatOutgoingTableViewCell
            cell.messageLabel.text = data.message
            cell.nameLabel.text = data.name
            return cell
        case .Other:
            let cell = tableView.dequeueReusableCell(cellType: ChatIncomingTableViewCell.self, for: indexPath) as! ChatIncomingTableViewCell
            cell.messageLabel.text = data.message
            cell.nameLabel.text = data.name
            return cell
        default:
            return UITableViewCell()
        }
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
    
    func websocketLogicDidFailed() {
        
    }
    
    func websocketLogicDidReceiveJoined(data: WebSocketActionDto) {
        
    }
    
    func websocketLogicDidReceiveRemoved(data: WebSocketActionDto) {
        
    }
    
    func websocketLogicDidReceiveMessage(data: WebSocketMessageDto) {
        vm.addMessage(data)
    }
    
    func websocketLogicDidReceiveError(data: WebSocketErrorDto) {
        
    }
}






