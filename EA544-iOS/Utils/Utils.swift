//
//  Utils.swift
//  EA544-iOS
//
//  Created by Uriel Battanoli on 5/16/22.
//

import Foundation

struct Utils {
    
    static func formatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }
    
    static func formatDate(date: Date?) -> String? {
        guard let date = date else { return nil }
        return formatter().string(from: date)
    }
}

extension Encodable {
    
    public func toDictionary() -> JSON {
        do {
            let data = try JSONEncoder().encode(self)
            let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            return json as? JSON ?? [:]
        } catch (let error) {
            print(Self.self)
            print(error)
        }
        return [:]
    }
}
