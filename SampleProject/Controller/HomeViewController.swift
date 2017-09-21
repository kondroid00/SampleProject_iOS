//
//  HomeViewController.swift
//  SampleProject
//
//  Created by 近藤浩市郎 on 2017/09/11.
//  Copyright © 2017 Koichiro Kondo. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class HomeViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addRoomButton: UIBarButtonItem!
    
    private let vm = HomeViewModel()
    private let dataSource = HomeDataSource()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerNib(RoomsTableViewCell.self)
        
        vm.fetchRoom()
        
        vm.rooms.bind(to: tableView.rx.items(dataSource: dataSource)).addDisposableTo(disposeBag)
        
        tableView.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return view.frame.height * 0.10
    }
}

class HomeDataSource: NSObject, UITableViewDataSource, RxTableViewDataSourceType {
    
    typealias Element = [RoomDto]
    
    var items: Element = []
    
    func tableView(_ tableView: UITableView, observedEvent: Event<Element>) -> Void {
        if case .next(let items) = observedEvent {
            self.items = items
            tableView.reloadData()
        }
    }
    
    //MARK: - TableView Delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(cellType: RoomsTableViewCell.self, for: indexPath)
        cell.setData(items[indexPath.row])
        return cell
    }
    
    
}
