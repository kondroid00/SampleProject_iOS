//
//  Extensions.swift
//  SampleProject
//
//  Created by 近藤浩市郎 on 2017/09/11.
//  Copyright © 2017 Koichiro Kondo. All rights reserved.
//

import Foundation
import UIKit

extension NSObject {
    class var className: String {
        return String(describing: self)
    }
}

extension Date {
    func toNanoMillis() -> Int64! {
        return Int64(self.timeIntervalSince1970 * 1000000)
    }
    
    func toMillis() -> Int64! {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
    
    func toSeconds() -> Int64! {
        return Int64(self.timeIntervalSince1970)
    }
}

extension UITableView {
    func registerNib<T: UITableViewCell>(_ cellType: T.Type) {
        register(UINib(nibName: cellType.className, bundle: nil), forCellReuseIdentifier: cellType.className)
    }
    
    func dequeueReusableCell<T: UITableViewCell>(cellType: T.Type, for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withIdentifier: cellType.className, for: indexPath) as! T
    }
}
