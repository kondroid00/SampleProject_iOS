//
//  AddRoomViewModel.swift
//  SampleProject
//
//  Created by 近藤浩市郎 on 2017/09/21.
//  Copyright © 2017 Koichiro Kondo. All rights reserved.
//

import Foundation
import RxSwift

class AddRoomViewModel: BaseViewModel {

    let name: BehaviorSubject<String> = BehaviorSubject(value: "")
    let theme: BehaviorSubject<String> = BehaviorSubject(value: "")
 
    let roomsModel = RoomsModel()
    
    func createRoom(onSuccess: @escaping () -> Void, onFailed: @escaping (Error) -> Void, onCompleted: @escaping () -> Void) {
        let params = RoomCreateRequest.Params()
        do {
            params.name = try self.name.value()
            params.theme = try self.theme.value()
        } catch {
            
        }
        roomsModel.createRoom(params).subscribeOn(MainScheduler.instance)
            .subscribe(
                onNext: {[weak self](data) in
                    if let room = data.room {
                        self?.name.onNext(room.name ?? "")
                        self?.theme.onNext(room.theme ?? "")
                    }
                    onSuccess()
                },
                onError: onFailed,
                onCompleted: onCompleted,
                onDisposed: {
                    
                }
        ).addDisposableTo(disposeBag)
        
    }


}
