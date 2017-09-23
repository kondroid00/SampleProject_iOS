//
//  RoomsModel.swift
//  SampleProject
//
//  Created by 近藤浩市郎 on 2017/09/16.
//  Copyright © 2017 Koichiro Kondo. All rights reserved.
//

import Foundation
import RxSwift

class RoomsModel {

    private let fetchRequest = RoomFetchRequest()
    private let createRequest = RoomCreateRequest()
    
    func fetchRooms(_ params: RoomFetchRequest.Params) -> Observable<RoomFetchRequest.Result> {
        return fetchRequest.request(params)
    }
    
    func createRoom(_ params: RoomCreateRequest.Params) -> Observable<RoomCreateRequest.Result> {
        return createRequest.request(params)
    }
    
    
}
