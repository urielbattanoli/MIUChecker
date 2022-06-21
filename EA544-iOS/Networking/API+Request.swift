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
        default:
            return API.baseURL.appendingPathComponent(path)
        }
    }
    
    var path: String {
        switch self {
        case .login: return "authentication"
        case .members(let id): return "members/\(id)"
        case .checkIn(let id): return "members/\(id)/checkin"
        case .transactions(let id): return "members/\(id)/checkin"
        case .saveAttendances: return "v1/api/attendance-records"
        case .getAttendances: return "v1/api/attendance-records"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .login, .checkIn, .saveAttendances: return .post
        default: return .get
        }
    }
    
    var encoding: ParameterEncoding {
        switch self {
        case .getAttendances: return URLEncoding.default
        default: return JSONEncoding.default
        }
    }
    
    var headers: HTTPHeaders {
        var headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        
        if let token = Defaults.shared.token {
            headers["Authorization"] = token
        }
        
        return headers
    }
}

