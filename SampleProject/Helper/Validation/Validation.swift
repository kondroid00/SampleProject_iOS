//
//  Validation.swift
//  SampleProject
//
//  Created by 近藤浩市郎 on 2017/09/24.
//  Copyright © 2017 Koichiro Kondo. All rights reserved.
//

import Foundation

struct Validation {

    static func textLength(text: String, min: Int? = nil, max: Int? = nil) -> String? {
        let count = text.characters.count
        
        var minResult = false
        if let min = min, min <= count {
            minResult = true
        }
        var maxResult = false
        if let max = max, max >= count {
            maxResult = true
        }
        
        if let min = min, let max = max, !(minResult && maxResult) {
            return "\(min)文字以上\(max)文字以下で入力してください。"
        }
        if let min = min, !minResult {
            return "\(min)文字以上で入力してください。"
        }
        if let max = max, !maxResult {
            return "\(max)文字以下で入力してください。"
        }
        
        return nil
    }

}
