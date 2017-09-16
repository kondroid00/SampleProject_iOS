//
//  HomeViewModel.swift
//  SampleProject
//
//  Created by 近藤浩市郎 on 2017/09/12.
//  Copyright © 2017 Koichiro Kondo. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class HomeViewModel: BaseViewModel {
    
    let rooms: BehaviorSubject<[RoomDto]> = BehaviorSubject(value: [])
    
    let roomsModel = RoomsModel()
    
    func fetchRoom() {
        let params = RoomFetchRequest.Params()
        roomsModel.fetchRooms(params).subscribeOn(MainScheduler.instance)
            .subscribe(
                onNext: {[weak self](data) in
                    self?.rooms.onNext(data.rooms ?? [])
                },
                onError: {[weak self](error) in
                    
                },
                onCompleted: {
            
                },
                onDisposed: {
                    
                }
        ).addDisposableTo(disposeBag)
    }
    
    
    
}
