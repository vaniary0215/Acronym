//
//  APIRequest.swift
//  Acronym
//
//  Created by Ashish Vani on 16/07/21.
//

import Foundation

extension URLRequest {
    
    init(_ resource: APIResource) {
        self.init(url: URL(string: resource.url)!, cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 100)
        self.httpMethod = resource.httpMethod.rawValue
    }
}

class APIManager {
    static func load<T: Codable>(_ resource: APIResource, parameter: Any?, codableType: T.Type, onSuccess: @escaping (SuccessCallBlock), onFailure: @escaping (FailureCallBlock)) {
        var allHTTPHeaderFields:[String:String] = [:]
        var request = URLRequest(resource)
        
        allHTTPHeaderFields["Content-Type"] = "application/json"
        allHTTPHeaderFields["Accept"] = "application/json"
        
        request.allHTTPHeaderFields = allHTTPHeaderFields
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                guard let responseCode = response as? HTTPURLResponse,
                      (200...299).contains(responseCode.statusCode) else {
                    do {
                        guard let reData = data else {
                            onFailure(ServerError.invalidResponse); return
                        }
                        let serverErrorModel = try JSONDecoder().decode(ServerError.self, from: reData)
                        onFailure(serverErrorModel); return
                    } catch let error {
                        print(error)
                        onFailure(ServerError.invalidResponse);
                    }
                    return;
                }
                
                if let err = error {
                    onFailure(ServerError(message: err.localizedDescription, code: "\(responseCode.statusCode)")); return
                }
                
                guard let reData = data else { onFailure(ServerError.invalidResponse); return }
                do {
                    let resModel = try JSONDecoder().decode(T.self, from: reData)
                    onSuccess(reData, resModel); return
                } catch let err {
                    onFailure(ServerError.invalidResponse); return
                }
            }
        }
        task.resume()
    }
}
