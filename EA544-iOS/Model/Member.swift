//
//  Member.swift
//  EA544-iOS
//
//  Created by Uriel Battanoli on 5/17/22.
//

import Foundation

final class Member: Codable {
    
    static var current: Member?
    
    let id: String
    private let firstName: String
    private let lastName: String
    private let roles: [String]
//    let badge: Badge
    
    var name: String { return firstName + " " + lastName }
    var isLocation: Bool { return roles.contains("LOCATION") }
}
