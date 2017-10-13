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
        didSet {
            if let token = self.token {
                if token.expiredAt! <= Date().toNanoMillis() {
                    self.token = nil
                }
            }
        }
    }
    
    var user: UserDto? {
        didSet {
           UserDefaults.standard.set(self.user?.id, forKey: AccountManager.UDUserIdKey)
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
