//
//  BaseRequest.swift
//  SampleProject
//
//  Created by 近藤浩市郎 on 2017/09/03.
//  Copyright © 2017 Koichiro Kondo. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire
import Unbox
import Wrap

class BaseRequest {
    
    class EmptyParams {}
    
    class BaseAuthParams {
        var token: String?
        
        init() {
            self.token = AccountManager.instance.getToken()
        }
    }
    
    private let path: String
    private let method: HTTPMethod
    private let url: String
    private (set) var requesting: Bool = false
    
    init(path: String, method: HTTPMethod = .post) {
        self.path = path
        self.method = method
        self.url = NetworkConstants.getApiUrl() + path
    }
    
    func request<T1 :Unboxable>() -> Observable<T1> {
        let params: EmptyParams? = nil
        return self.request(params)
    }
    
    func request<T1 :Unboxable>(_ params: UserCreateRequest.Params?) -> Observable<T1> {
        requesting = true
        return Observable.create {[weak self](observer) in
            guard let weakSelf = self else {
                return Disposables.create()
            }
            var requestParams :Parameters = [:]
            if let params = params {
                do {
                    requestParams = try wrap(params)
                } catch {
                    return Disposables.create()
                }
            }
            let request = Alamofire.request(weakSelf.url, method: weakSelf.method, parameters: requestParams, encoding: JSONEncoding.default).responseData {(response) in
                guard let weakSelf = self else {
                    return
                }
                defer {
                    weakSelf.requesting = false
                }
                do {
                    switch response.result {
                    case .success(let data):
                        let result: T1 = try unbox(data: data)
                        observer.onNext(result)
                        observer.onCompleted()
                    case .failure(let error):
                        observer.onError(error)
                    }
                } catch(let error) {
                    observer.onError(error)
                }
            }
            print("===========API============")
            print(request.debugDescription)
            
            return Disposables.create {
                request.cancel()
            }
        }
    }
    
    func request<T1 :Unboxable, T2>(_ params: T2?) -> Observable<T1> {
        requesting = true
        return Observable.create {[weak self](observer) in
            guard let weakSelf = self else {
                return Disposables.create()
            }
            var requestParams :Parameters = [:]
            if let params = params {
                do {
                    requestParams = try wrap(params)
                } catch {
                    return Disposables.create()
                }
            }
            let request = Alamofire.request(weakSelf.url, method: weakSelf.method, parameters: requestParams, encoding: JSONEncoding.default).responseData {(response) in
                guard let weakSelf = self else {
                    return
                }
                defer {
                    weakSelf.requesting = false
                }
                do {
                    switch response.result {
                    case .success(let data):
                        let result: T1 = try unbox(data: data)
                        observer.onNext(result)
                        observer.onCompleted()
                    case .failure(let error):
                        observer.onError(error)
                    }
                } catch(let error) {
                    observer.onError(error)
                }
            }
            
            return Disposables.create {
                request.cancel()
            }
        }
    }
    
}
