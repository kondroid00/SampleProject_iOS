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
    
    var rooms: Variable<[RoomDto]?> = Variable([])
    
    let roomsModel = RoomsModel()
    
    func fetchRoom() {
        let params = RoomFetchRequest.Params()
        roomsModel.fetchRooms(params).subscribeOn(MainScheduler.instance)
            .subscribe(
                onNext: { data in
            
                },
                onError: {error in
                    
                },
                onCompleted: {
            
                },
                onDisposed: {
                    
                }
        )
    }
    
    
    
}
