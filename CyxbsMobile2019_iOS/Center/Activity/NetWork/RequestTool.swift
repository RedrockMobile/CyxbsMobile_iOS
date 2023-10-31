//
//  RequestTool.swift
//  CyxbsMobile2019_iOS
//
//  Created by 许晋嘉 on 2023/8/20.
//  Copyright © 2023 Redrock. All rights reserved.
//

import Foundation
import Alamofire

typealias ActivityClientResponse = (Any?) -> Void

class ActivityClient: NSObject {
    
    static let shared = ActivityClient()
    
    private override init() {
        
    }
    
    func request(url: String,
                 method: HTTPMethod,
                 headers: [String: String]?,
                 parameters: Parameters?,
                 completion: @escaping ActivityClientResponse,
                 failure: ((Error) -> Void)? = nil) {
        
        var requestHeaders: [String: String]
        var requestURL: URL!

        if headers != nil {
            requestHeaders = headers!
        } else {
            requestHeaders = [String: String]()
        }
        
        if let baseURL = UserDefaults.standard.object(forKey: "baseURL") as? String {
            requestURL = URL(string: baseURL + url)
        } else {
            requestURL = URL(string:"https://be-prod.redrock.cqupt.edu.cn/" + url)
        }
        
        if let token = UserItemTool.defaultItem().token {
            requestHeaders["Authorization"] = "Bearer \(token)"
        }
        AF.request(requestURL, method: method, parameters: parameters ?? nil, encoding: URLEncoding.default, headers: HTTPHeaders(requestHeaders)).responseJSON { (response) in
            
            switch response.result {
    
                case let .success(data):
                    completion(data)
                    break
    
                case let .failure(error):
                    failure?(error)
                    completion(nil)
                    print(error)
                    break
            }
        }
    }
    
    func upload(
        url: String,
        method: HTTPMethod,
        headers: [String: String]?,
        parameters: Parameters?,
        fileData: Data?,
        withName: String?,
        fileName: String?,
        mimeType: String?,
        completion: @escaping ActivityClientResponse,
        failure: ((Error) -> Void)? = nil) {

        var requestHeaders: [String: String]
        var requestURL: URL!

        if headers != nil {
            requestHeaders = headers!
        } else {
            requestHeaders = [String: String]()
        }

        if let baseURL = UserDefaults.standard.object(forKey: "baseURL") as? String {
            requestURL = URL(string: baseURL + url)
        } else {
            requestURL = URL(string: "https://be-prod.redrock.cqupt.edu.cn/" + url)
        }

        if let token = UserItemTool.defaultItem().token {
            requestHeaders["Authorization"] = "Bearer \(token)"
        }

        AF.upload(multipartFormData: { multipartFormData in
            for (key, value) in parameters ?? [:] {
                if let valueData = String(describing: value).data(using: .utf8) {
                    multipartFormData.append(valueData, withName: key)
                }
            }

            // Append file data if available
            if let fileData = fileData, let fileName = fileName, let mimeType = mimeType, let withName = withName {
                multipartFormData.append(fileData, withName: withName, fileName: fileName, mimeType: mimeType)
            }

        }, to: requestURL, method: method, headers: HTTPHeaders(requestHeaders))
        .responseJSON { response in
            switch response.result {
            case let .success(data):
                completion(data)
            case let .failure(error):
                failure?(error)
                completion(nil)
                print(error)
            }
        }
    }
}


