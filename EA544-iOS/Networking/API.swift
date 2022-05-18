//
//  API.swift
//  EA544-iOS
//
//  Created by Uriel Battanoli on 5/16/22.
//

import Foundation

typealias JSON = [String : Any]

enum API<T: Codable> {
    
    case login
    case members(id: String)
    case checkIn(id: String)
    case transactions(id: String)
}

public struct AppError: Codable, Error, LocalizedError {
    
    public static var unknown: AppError {
        return AppError(status: -1, error: "Unknown")
    }
    
    public let status: Int
    private let error: String
    
    public var errorDescription: String? {
        return error
    }
}

extension Error {
    public var asAppError: AppError? {
        self as? AppError
    }
}

struct EmptyResult: Codable { }
