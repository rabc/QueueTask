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
    
    public func get<T: Decodable>(_ key: UserDefaultsKeys) -> T? {
        guard let data = userDefaults.data(forKey: key.rawValue) else {
            return nil
        }
        
        do {
            let result = try JSONDecoder().decode(T.self, from: data)
            return result
        } catch {
            return nil
        }
    }
    
    public func remove(_ key: UserDefaultsKeys) {
        userDefaults.removeObject(forKey: key.rawValue)
    }
    
    public func set<T: Encodable>(_ value: T, for key: UserDefaultsKeys) {
        do {
            let data = try JSONEncoder().encode(value)
            userDefaults.set(data, forKey: key.rawValue)
        } catch { }
    }
    
}
