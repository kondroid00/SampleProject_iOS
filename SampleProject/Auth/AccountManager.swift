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
    
    var token: String?
    
    static let instance: AccountManager = AccountManager()
    
    func hasToken() -> Bool {
        if UserDefaults.standard.string(forKey: AccountManager.UDTokenKey) != nil {
            return true
        }
        return false
    }
    
    func getToken() -> String? {
        if self.token != nil {
            return self.token
        } else {
            self.token = UserDefaults.standard.string(forKey: AccountManager.UDTokenKey)
            return self.token
        }
    }
    
    func saveToken(_ token: String) {
        self.token = token
        UserDefaults.standard.set(token, forKey: AccountManager.UDTokenKey)
    }
    
    func hasUserId() -> Bool {
        if UserDefaults.standard.string(forKey: AccountManager.UDUserIdKey) != nil {
            return true
        }
        return false
    }
    
    func getUserId() -> String? {
        return UserDefaults.standard.string(forKey: AccountManager.UDUserIdKey)
    }
    
    func saveUserId(_ userId: String) {
        UserDefaults.standard.set(userId, forKey: AccountManager.UDUserIdKey)
    }
}
