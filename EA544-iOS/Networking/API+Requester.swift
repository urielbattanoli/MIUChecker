//
//  API+Requester.swift
//  EA544-iOS
//
//  Created by Uriel Battanoli on 5/16/22.
//

import Foundation
import Alamofire

extension API {
    
    private func logIfNeeded(params: Any? = nil, response: AFDataResponse<Data>) {
        Logger.log(.networking, info: "SENT (\(self.method.rawValue): \(self.url)) \nHEADERS:\(headers.dictionary)", object: "\n\(String(describing: params))")
        if let data = response.data {
            if data.count > 1024 * 1024 {
                Logger.log(.networking, info: "RECEIVED", object: ">> Large data <<")
            } else {
                Logger.log(.networking, info: "RECEIVED", object: "\n\(String(data: data, encoding: .utf8) ?? "")")
            }
        }
    }
    
    private func parse(response: AFDataResponse<Data>) -> (Swift.Result<T, Error>) {
        let statusCode = response.response?.statusCode ?? 0
        
        let decoder = JSONDecoder()
        
        switch response.result {
        case .success(let data) where statusCode >= 200 && statusCode <= 299:
            do {
                let object = try decoder.decode(T.self, from: data)
                return .success(object)
            } catch {
                #if DEBUG
                Logger.log(
                    .custom("🖥 (Parser)"),
                    info: "1️⃣ \(String(describing: T.self))",
                    object: "\n\(error.localizedDescription)"
                )
                #endif
            }
            
            return .failure(AppError.unknown)
            
        case .success(let data):
            do {
                let object = try decoder.decode(AppError.self, from: data)
                if object.status == 209 {
                    NotificationCenter.default.post(name: NSNotification.Name.init("application_logout"), object: nil)
                }
                guard object.status == 223 || object.status == 228 else { return .failure(object) }
                do {
                    let dict = try JSONSerialization.jsonObject(with: data, options: []) as? JSON
                    let error = dict?["error"] as? String
                    guard let data = error?.data(using: .utf8) else { return .failure(object) }
                    let object = try decoder.decode(T.self, from: data)
                    return .success(object)
                } catch {
                    return .failure(object)
                }
            } catch {
                #if DEBUG
                Logger.log(
                    .custom("🖥 (Parser)"),
                    info: "1️⃣ \(String(describing: AppError.self))",
                    object: "\n\(error.localizedDescription)"
                )
                #endif
            }
            
            return .failure(AppError.unknown)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    @discardableResult
    func request(params: JSON? = nil, progress: ((Progress) -> Void)? = nil, completion: ((Swift.Result<T, Error>) -> Void)? = nil) -> DataRequest {
        let req = AF.request(url,
                             method: method,
                             parameters: params,
                             encoding: encoding,
                             headers: headers)
        return request(request: req,
                       params: params as Any,
                       progress: progress,
                       completion: completion)
    }
    
    @discardableResult
    func request(params: [JSON], progress: ((Progress) -> Void)? = nil, completion: ((Swift.Result<T, Error>) -> Void)? = nil) -> DataRequest {
        let data = try? JSONSerialization.data(withJSONObject: params)
        var req = URLRequest(url: url)
        req.method = method
        req.httpBody = data
        req.headers = headers
        return request(request: AF.request(req),
                       params: params,
                       progress: progress,
                       completion: completion)
    }
        
    @discardableResult
    private func request(request: DataRequest, params: Any, progress: ((Progress) -> Void)? = nil, completion: ((Swift.Result<T, Error>) -> Void)? = nil) -> DataRequest {
        
        guard let progress = progress else {
            request
                .validate(statusCode: 200...600)
                .responseData(
                    completionHandler: { response in
                        self.logIfNeeded(params: params, response: response)
                        if let completion = completion {
                            let result = self.parse(response: response)
                            DispatchQueue.main.async { completion(result) }
                        }
                    }
                )
            
            return request
        }
        
        request
            .downloadProgress(queue: .main, closure: { prog in
                progress(prog)
            })
        
        return request
    }
    
    public func upload(data: Data, completion: ((Swift.Result<T, Error>) -> Void)? = nil) {
        var headerNew = self.headers
        
        switch self {
        default:
            headerNew["Content-Type"] = "image/png"
        }
        
        AF.upload(data, to: url, headers: headerNew)
            .validate()
            .responseData { response in
                self.logIfNeeded(params: nil, response: response)
                if let completion = completion {
                    let result = self.parse(response: response)
                    DispatchQueue.main.async { completion(result) }
                }
            }
    }
}
