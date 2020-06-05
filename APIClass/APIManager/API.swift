//
//  API.swift
//  Tomato
//
//  Copyright © 2019 mac-00020. All rights reserved.


import Foundation
import Alamofire

fileprivate let ApiEnv: APIEnvironment = .staging

fileprivate enum APIEnvironment {
    case staging
    case live
}

public var BaseURL: String {
    switch ApiEnv {
    case .staging:
        return "http://192.168.10.102/api/"
    case .live:
        return "https://serverdomain.com/api/"
    }
}

//MARK :- APIs List
enum APIName {
    
    case RandomDog
    
    var name: String {
        
        switch self {
        case .RandomDog:
            return "https://dog.ceo/api/breeds/image/random"
        }
    }
}


/**
 func requestForPost() {
     
     APIRequest(apiName: .Post, method: .post).request(model: MDL.self) { [weak self] (request, dataModel) in
         guard let _ = self else { return }
         //guard let arrPost = dataModel?.data else { return }
         print(request.fullResponse.toJson())
     }
 }
*/
