//
//  SignUpViewModel.swift
//  SampleProject
//
//  Created by 近藤浩市郎 on 2017/09/10.
//  Copyright © 2017 Koichiro Kondo. All rights reserved.
//

import Foundation
import RxSwift

class SignUpViewModel: BaseViewModel {
    
    var name: String?
    
    let userModel = UsersModel()
    
    func signUp(onSuccess: @escaping () -> Void, onFailed: @escaping (Error) -> Void) {
        let params = UserCreateRequest.Params()
        params.name = name
        userModel.createUser(params)
            .subscribeOn(SerialDispatchQueueScheduler(qos: .userInitiated))
            .observeOn(MainScheduler.instance)
            .subscribe(
                onNext: { data in
                    AccountManager.instance.token = data.token
                    AccountManager.instance.user = data.user
                    onSuccess()
                },
                onError: onFailed
            ).addDisposableTo(disposeBag)
    }
}
