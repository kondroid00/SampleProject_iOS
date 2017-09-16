//
//  AuthModel.swift
//  SampleProject
//
//  Created by 近藤浩市郎 on 2017/09/03.
//  Copyright © 2017 Koichiro Kondo. All rights reserved.
//

import Foundation
import RxSwift

class AuthModel {
    
    private let loginRequest = LoginRequest()
    
    func login(_ params: LoginRequest.Params) -> Observable<LoginRequest.Result> {
        return loginRequest.request(params)
    }
    
}
