//
//  Common.swift
//  SampleProject
//
//  Created by 近藤浩市郎 on 2017/10/12.
//  Copyright © 2017 Koichiro Kondo. All rights reserved.
//

import Foundation
import RxSwift
import Unbox

struct Helper {
    static func parseObservable<T: Unboxable>(jsonString: String) -> Observable<T> {
        return Observable.create {observer in
            do {
                if let jsonData = jsonString.data(using: String.Encoding.utf8) {
                    let value: T = try unbox(data: jsonData)
                    observer.onNext(value)
                } else {
                    throw OptionalError.UnwrapFailed
                }
            } catch {
                observer.onError(error)
            }
            return Disposables.create()
        }
    }
}
