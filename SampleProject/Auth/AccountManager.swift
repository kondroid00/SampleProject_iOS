//
//  AccountManager.swift
//  SampleProject
//
//  Created by 近藤浩市郎 on 2017/09/06.
//  Copyright © 2017 Koichiro Kondo. All rights reserved.
//

import Foundation

class AccountManager {
    
    private static let UDTokenKey = "token"
    private static let UDUserIdKey = "user_id"
    
    //private var token: String?
    
    var token: TokenDto? {
        get {
            if let token = self.token {
                if token.expiredAt! > Date().toNanoMillis() {
                    return token
                }
            }
            return nil
        }
        
        set {}
    }
    
    var user: UserDto? {
        get {
            return self.user
        }
        
        set {
           UserDefaults.standard.set(newValue?.id, forKey: AccountManager.UDUserIdKey)
        }
    }
    
    static let instance: AccountManager = AccountManager()
    
    func hasUserId() -> Bool {
        if UserDefaults.standard.string(forKey: AccountManager.UDUserIdKey) != nil {
            return true
        }
        return false
    }
    
    func getUserId() -> String? {
        return UserDefaults.standard.string(forKey: AccountManager.UDUserIdKey)
    }
}
