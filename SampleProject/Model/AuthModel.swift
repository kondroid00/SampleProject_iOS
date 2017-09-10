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
    
    func login(_ params: LoginRequest.Params) -> Observable<LoginResult> {
        return loginRequest.request(params)
    }
    
}
