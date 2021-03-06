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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerNib(RoomsTableViewCell.self)

        vm.rooms
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        tableView.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        vm.fetchRoom()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FromHomeToChat" {
            let vc = segue.destination as? ChatViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                do {
                    let rooms = try vm.rooms.value()
                    let selectedRoom = rooms[indexPath.row]
                    vc?.room = selectedRoom
                } catch {
                    
                }
            }
        }
    }
}

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return view.frame.height * 0.10
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "FromHomeToChat", sender: nil)
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
