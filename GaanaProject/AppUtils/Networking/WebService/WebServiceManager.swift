//
//  WebServicceManager.swift
//  GaanaProject
//
//  Created by Shubham Gupta on 20/06/20.
//  Copyright © 2020 Shubham Gupta. All rights reserved.
//

import Foundation

public enum Method: String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case DELETE = "DELETE"
}

class WebServiceManager: NSObject {
    public static let shared = WebServiceManager()
    let session: URLSession

    private override init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        configuration.urlCache = nil
        self.session = URLSession(configuration: configuration)
        super.init()
    }
    
    func executeQuery(method: Method = .GET, requestPath:String, queryParameters:[String:Any]?, payLoad:NSDictionary?,headers:[String:String]?, completion: @escaping ([String:Any]?, String?) -> Void){
        
        if !ReachabilityManager.sharedInstance.isNetworkAvailable {
            completion(nil,Constants.networkError)
            return
        }
        
        guard var urlComponent = URLComponents(string: requestPath),let url = urlComponent.url else {
            completion(nil,Constants.genericError)
            return
        }
        
        if let queryParam = queryParameters {
            let queryItems = queryParam.map  { URLQueryItem(name: $0.key, value: $0.value as? String) }
            urlComponent.queryItems = queryItems
        }
        
        //Now make `URLRequest` and set body and headers with it
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.timeoutInterval = 30
        if let payloadValue = payLoad {
            request.httpBody = try? JSONSerialization.data(withJSONObject: payloadValue)
        }
        request.allHTTPHeaderFields = headers
        
        let task = self.session.dataTask(with: request) { (data, urlResponse, error) in

            DispatchQueue.main.async {
                if error != nil{
                    print(error ?? "")
                    if let errorDescription = error?.localizedDescription {
                        completion(nil, errorDescription)
                        return
                    }
                    completion(nil,Constants.genericError)
                }else{
                    if let httpStatus = urlResponse as? HTTPURLResponse {
                        switch httpStatus.statusCode {
                            case 200...299:
                                do {
                                    if let data = data {
                                        let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]
                                        completion(json,nil)
                                        return
                                    }
                                    completion(nil,Constants.genericError)
                                }
                                catch {
                                    completion(nil,Constants.genericError)
                                }
                            
                            default :
                                completion(nil,Constants.genericError)
                        }
                    }else{
                        completion(nil, "Unable to cast http response")
                    }
                }
            }
        }
        task.resume()
    }
}
