//
//  UIViewExtension.swift
//  SampleProject
//
//  Created by 近藤浩市郎 on 2017/09/03.
//  Copyright © 2017 Koichiro Kondo. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    enum BorderSide {
        case Top
        case Right
        case Bottom
        case Left
    }
    
    // 枠線の色
    @IBInspectable var borderColor: UIColor? {
        get {
            return layer.borderColor.map { UIColor(cgColor: $0) }
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    // 枠線のWidth
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    // 角丸設定
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    
    //-------------------------------------------------------------------------
    // コーディング
    //-------------------------------------------------------------------------
    // 枠線
    func addBorder(borderSide: [BorderSide], width: CGFloat, color: UIColor) {
        self.layer.sublayers = nil
        self.layer.masksToBounds = true
        
        if borderSide.contains(.Top) {
            let topLine = CALayer()
            topLine.backgroundColor = color.cgColor
            topLine.frame = CGRect(x: 0.0, y: 0.0, width: self.frame.width, height: width)
            self.layer.addSublayer(topLine)
        }
        if borderSide.contains(.Left) {
            let leftLine = CALayer()
            leftLine.backgroundColor = color.cgColor
            leftLine.frame = CGRect(x: 0.0, y: 0.0, width: width, height: self.frame.height)
            self.layer.addSublayer(leftLine)
        }
        if borderSide.contains(.Bottom) {
            let bottomLine = CALayer()
            bottomLine.backgroundColor = color.cgColor
            bottomLine.frame = CGRect(x: 0.0, y: self.frame.height - width, width: self.frame.width, height: width)
            self.layer.addSublayer(bottomLine)
        }
        if borderSide.contains(.Right) {
            let rightLine = CALayer()
            rightLine.backgroundColor = color.cgColor
            rightLine.frame = CGRect(x: self.frame.width - width, y: 0.0, width: width, height: self.frame.height)
            self.layer.addSublayer(rightLine)
        }
    }

    
}
