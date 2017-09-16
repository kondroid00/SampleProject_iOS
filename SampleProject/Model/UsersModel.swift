//
//  UsersModel.swift
//  SampleProject
//
//  Created by 近藤浩市郎 on 2017/09/10.
//  Copyright © 2017 Koichiro Kondo. All rights reserved.
//

import Foundation
import RxSwift

class UsersModel {
    
    private let createRequest = UserCreateRequest()
    
    func createUser(_ params: UserCreateRequest.Params) -> Observable<UserCreateRequest.Result> {
        return createRequest.request(params)
    }
    
}
