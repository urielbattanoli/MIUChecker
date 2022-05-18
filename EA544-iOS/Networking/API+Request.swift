//
//  API+Request.swift
//  EA544-iOS
//
//  Created by Uriel Battanoli on 5/16/22.
//

import Foundation
import Alamofire

extension API {
    
    var url: URL {
        switch self {
        case .login: return URL(string: "http://localhost:5080")!.appendingPathComponent(path)
        default:
            return API.baseURL.appendingPathComponent(path)
        }
    }
    
    var path: String {
        switch self {
        case .login: return "auth/realms/ea544/protocol/openid-connect/token"
        case .members(let id): return "members/\(id)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .login: return .post
        default: return .get
        }
    }
    
    var encoding: ParameterEncoding {
        switch self {
        case .login: return URLEncoding.default
        default: return JSONEncoding.default
        }
    }
    
    var headers: HTTPHeaders {
        if case .login = self {
            return ["Content-Type": "application/x-www-form-urlencoded",
                    "Authorization": "Basic bG9naW4tYXBwOg=="]
        }
        var headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        
        if let token = Defaults.shared.token {
            headers["Authorization"] = token
        }
        return headers
    }
}

