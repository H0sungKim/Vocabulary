//
//  UserDefaultManager.swift
//  JapaneseBenkyo
//
//  Created by 김호성 on 2/13/24.
//

import Foundation

private enum UserDefaultEnum: String {
    case vocabularyBookmark
    case kanjiBookmark
}

class UserDefaultManager {
    
    public static let shared = UserDefaultManager()
    
    private init() {
    }
    
    var vocabularyBookmark: String {
        get {
            return UserDefaults.standard.value(forKey: UserDefaultEnum.vocabularyBookmark.rawValue) as? String ?? ""
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: UserDefaultEnum.vocabularyBookmark.rawValue)
        }
    }
    
    var kanjiBookmark: String {
        get {
            return UserDefaults.standard.value(forKey: UserDefaultEnum.kanjiBookmark.rawValue) as? String ?? ""
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: UserDefaultEnum.kanjiBookmark.rawValue)
        }
    }
    
}