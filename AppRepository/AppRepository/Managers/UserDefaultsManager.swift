// Created on 22/02/2020

import Foundation

public final class UserDefaultsManager {
    
    public enum UserDefaultsKeys: String {
        case hour
    }
    
    let userDefaults: UserDefaults
    
    public init(userDefaults: UserDefaults = UserDefaults.standard) {
        self.userDefaults = userDefaults
    }
    
    public func get<T>(_ key: UserDefaultsKeys) -> T? {
        return userDefaults.object(forKey: key.rawValue) as? T
    }
    
    public func remove(_ key: UserDefaultsKeys) {
        userDefaults.removeObject(forKey: key.rawValue)
    }
    
    public func set(_ value: Any, for key: UserDefaultsKeys) {
        userDefaults.set(value, forKey: key.rawValue)
    }
    
}
