//
//  APIRequest.swift
//  Tomato
//
//  Copyright © 2019 mac-00020. All rights reserved.
//

import Foundation
import Alamofire
import UIKit

typealias Json = [String:Any]

enum RequestType {
    case queryString
    case httpBody
    case `default`
    
    var type: ParameterEncoding {
        
        switch self {
        case .queryString:
            return URLEncoding.queryString
        case .httpBody:
            return URLEncoding.httpBody
        case .default:
            return JSONEncoding.default
        }
    }
}

class APIRequest {
    
    var apiName: APIName
    var method: HTTPMethod
    var params: Json
    var encodingType : RequestType
    var dataRequest : DataRequest?
    var isRequestRunning = false
    
    init(apiName: APIName, params: Json = [:],method: HTTPMethod = .post, encodingType : RequestType = .httpBody) {
        
        self.apiName = apiName
        self.params = params
        self.method = method
        self.encodingType = encodingType
    }
    
    func request(responseHandler : @escaping ((APIResposne)->Void)) {
        if self.isRequestRunning{
            self.cancel()
        }
        if !isConnectedToInternet() {
            return
        }
        isRequestRunning = true
        dataRequest = APIManager.shared.request(request: self, responseHandler: { (request) in
            self.checkAPIRequestStatus(request: request)
            responseHandler(request)
        })
    }
    
    func request<T>(model:T.Type, responseHandler : @escaping ((APIResposne, T?)->Void)) where T : Codable {
        if self.isRequestRunning{
            self.cancel()
        }
        if !isConnectedToInternet() {
            return
        }
        isRequestRunning = true
        
        dataRequest = APIManager.shared.request(request: self, responseHandler: { (request) in

                guard let apiResonse: T = request.fullResponse.parseResponse() else {
                    responseHandler(request, nil)
                    return
                }
                responseHandler(request, apiResonse)
        })
    }
    
    @discardableResult
    func checkAPIRequestStatus(request: APIResposne) -> Bool {
        
        guard request.status != .clientError else {
            print("API Status Code : \(request.statusCode) ")
            print("Message : \(request.message) ")
            /* `Types of error`
             - Url not found : 400
             - Un-authorized access. : 401
             - Method not valid : 400
             */
            return false
        }
        guard request.status == .success else{
            return false
        }
        return true
    }
    
    func cancel() {
        dataRequest?.cancel()
        self.isRequestRunning = false
    }
}
