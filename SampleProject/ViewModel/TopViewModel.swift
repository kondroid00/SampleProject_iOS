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
    
    func login(onSuccess: @escaping () -> Void, onFailed: @escaping (Error) -> Void) {
        let params = LoginRequest.Params()
        params.userId = AccountManager.instance.getUserId()
        authModel.login(params).subscribeOn(MainScheduler.instance)
            .subscribe(
                onNext: { data in
                    onSuccess()
                },
                onError: {error in
                    onFailed(error)
                },
                onCompleted: {
            
                },
                onDisposed: {
                }
        ).addDisposableTo(disposeBag)
    }
}
