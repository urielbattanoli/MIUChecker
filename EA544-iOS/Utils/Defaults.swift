//
//  Defaults.swift
//  EA544-iOS
//
//  Created by Uriel Battanoli on 5/17/22.
//

import Foundation

public final class Defaults {
    
    public static var shared = Defaults()
    
    @UserDefault("token", defaultValue: nil)
    public var token: String?
    
    @UserDefault("location_id", defaultValue: "628541c78c24ef569751ccc8")
    public var location_id: String
    
    @UserDefault("plan_id", defaultValue: "628541ce8c24ef569751ccc9")
    public var plan_id: String
    
    @UserDefault("attendances", defaultValue: [])
    public var attendances: [JSON]
}

@propertyWrapper
public struct UserDefault<T> {
    let key: String
    let defaultValue: T
    private var userDefaults: UserDefaults {
        return UserDefaults(suiteName: "group.social.flockr.flockr.group")!
    }
    
    init(_ key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    public var projectedValue: UserDefault<T> { self }
    
    public var wrappedValue: T {
        get {
            return userDefaults.object(forKey: key) as? T ?? defaultValue
        }
        set {
            userDefaults.set(newValue, forKey: key)
        }
    }
    
    public func remove() {
        userDefaults.removeObject(forKey: key)
    }
}
