//
//  TopViewModel.swift
//  SampleProject
//
//  Created by 近藤浩市郎 on 2017/09/03.
//  Copyright © 2017 Koichiro Kondo. All rights reserved.
//

import Foundation
import RxSwift

class TopViewModel: BaseViewModel {
    
    let authModel = AuthModel()
    let userModel = UsersModel()
    
    func login() {
        let params = LoginRequest.Params()
        params.userId = AccountManager.instance.getUserId()
        authModel.login(params).subscribeOn(MainScheduler.instance)
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
    
    func signUp() {
        let params = UserCreateRequest.Params()
        params.name = "test"
        userModel.createUser().subscribeOn(MainScheduler.instance)
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
