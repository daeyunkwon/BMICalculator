//
//  UserDefaultsManager.swift
//  BMICalculator
//
//  Created by 권대윤 on 5/31/24.
//

import UIKit

struct UserDefaultsManager {
    
    static var nickname: String? {
        get {
            let nickname = UserDefaults.standard.string(forKey: "nickname")
            return nickname
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "nickname")
        }
    }
    
    static var height: String? {
        get {
            let height = UserDefaults.standard.string(forKey: "height")
            return height
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "height")
        }
    }
    
    static var weight: String? {
        get {
            let weight = UserDefaults.standard.string(forKey: "weight")
            return weight
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "weight")
        }
    }
    
    static func removeNickname() {
        UserDefaults.standard.removeObject(forKey: "nickname")
    }
    
    static func removeHeight() {
        UserDefaults.standard.removeObject(forKey: "height")
    }
    
    static func removeWeight() {
        UserDefaults.standard.removeObject(forKey: "weight")
    }
}
