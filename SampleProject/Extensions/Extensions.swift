//
//  Extensions.swift
//  SampleProject
//
//  Created by 近藤浩市郎 on 2017/09/11.
//  Copyright © 2017 Koichiro Kondo. All rights reserved.
//

import Foundation

extension NSObject {
    class var className: String {
        return String(describing: self)
    }
}

extension Date {
    func toNanoMillis() -> Int64! {
        return Int64(self.timeIntervalSince1970 * 1000000)
    }
}

