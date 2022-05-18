//
//  API.swift
//  EA544-iOS
//
//  Created by Uriel Battanoli on 5/16/22.
//

import Foundation

public typealias JSON = [String : Any]

public enum API<T: Codable> {
    
    case login
    case members(id: String)
}

public struct AppError: Codable, Error, LocalizedError {
    
    public static var unknown: AppError {
        return AppError(code: -1, error: "Unknown")
    }
    
    public let code: Int
    public let error: String
    
    public var errorDescription: String? {
        return error
    }
}

extension Error {
    public var asAppError: AppError? {
        self as? AppError
    }
}
