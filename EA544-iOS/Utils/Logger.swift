//
//  Logger.swift
//  EA544-iOS
//
//  Created by Uriel Battanoli on 5/16/22.
//

import Foundation

public final class Logger {
    
    private static let logQueue =  DispatchQueue(label: "edu.miu.logger", attributes: .concurrent)
    
    public static let standard = Logger()
    
    static public func log(_ tag: Tag, info: String, object: Any?, caller: String? = nil, line: Int = #line, file: String = #file) {
        Logger.logQueue.sync {
            
            var callerDescription = ""
            if let caller = caller {
                callerDescription = " - \(caller)"
            }
            
            var fileDescription: String = String(file.split(separator: "/").last ?? "")
            fileDescription = "\(fileDescription)#\(line)"
            
            var objectDescription = "nil"
            if let object = object {
                objectDescription = String(describing: object)
            }
            if objectDescription.contains("\n") {
                objectDescription = "\n\(objectDescription.tabbedByNewLine)"
            }
            
            print("\(tag.shortDesc) [\(fileDescription)\(callerDescription)]: \(info) ▶︎ \(objectDescription)\n")
            
        }
    }
}

extension Logger {
    
    public enum Tag {
        case debug
        case networking
        case error
        case custom(String)
        
        var shortDesc: String {
            switch self {
            case .debug: return "⚪️ (Debug)"
            case .networking: return "⚫️ (Networking)"
            case .error: return "🔴 (Error)"
            case .custom(let name): return name
            }
        }
    }
}
