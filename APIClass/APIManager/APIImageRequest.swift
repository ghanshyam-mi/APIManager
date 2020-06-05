//
//  APIImageRequest.swift
//  SetupApp
//
//  Copyright © 2020 mac-00020. All rights reserved.
//

import Foundation
import Alamofire
import UIKit

class APIImageRequest: APIRequest {
    
    var singleImage: [String : UploadMedia]
    var uploadingProgress : ((Double) -> Void)?
    
    init(apiName: APIName, params: Json = [:], imageParams: [String : UploadMedia], method: HTTPMethod = .post, encodingType : RequestType = .httpBody) {
        self.singleImage = imageParams
        super.init(apiName: apiName, params: params, method: method, encodingType: encodingType)
    }
    
    override func request(responseHandler :  @escaping ((APIResposne)->Void)) {
        if self.isRequestRunning{
            self.cancel()
        }
        if !isConnectedToInternet() {
            return
        }
        APIManager.shared.requestWithImage(request: self, responseHandler: { (request) in
            self.checkAPIRequestStatus(request: request)
            responseHandler(request)
        })
    }
    
    override func request<T>(model:T.Type, responseHandler : @escaping ((APIResposne, T?)->Void)) where T : Codable {
        if self.isRequestRunning{
            self.cancel()
        }
        if !isConnectedToInternet() {
            return
        }
        APIManager.shared.requestWithImage(request: self, responseHandler: { (request) in
            
            if self.checkAPIRequestStatus(request: request) {
                guard let apiResonse: T = request.fullResponse.parseResponse() else {
                    responseHandler(request, nil)
                    return
                }
                responseHandler(request, apiResonse)
            }
        })
    }
}

class APIImagesRequest: APIRequest {
    
    var multipleImage: [String : [UploadMedia]]
    var uploadingProgress : ((Double) -> Void)?
    
    init(apiName: APIName, params: Json = [:], imagesParams: [String : [UploadMedia]], method: HTTPMethod = .post, encodingType : RequestType = .httpBody) {
        self.multipleImage = imagesParams
        super.init(apiName: apiName, params: params, method: method, encodingType: encodingType)
    }
    
    override func request(responseHandler :  @escaping ((APIResposne)->Void)) {
        if self.isRequestRunning{
            self.cancel()
        }
        if !isConnectedToInternet() {
            return
        }
        APIManager.shared.requestWithImages(request: self, responseHandler: { (request) in
            self.checkAPIRequestStatus(request: request)
            responseHandler(request)
        })
    }
    
    override func request<T>(model:T.Type, responseHandler : @escaping ((APIResposne, T?)->Void)) where T : Codable {
       if self.isRequestRunning{
           self.cancel()
       }
        if !isConnectedToInternet() {
            return
        }
        APIManager.shared.requestWithImages(request: self, responseHandler: { (request) in
            
            if self.checkAPIRequestStatus(request: request) {
                guard let apiResonse: T = request.fullResponse.parseResponse() else {
                    responseHandler(request, nil)
                    return
                }
                responseHandler(request, apiResonse)
            }
        })
    }
}

enum MediaType {
    
    case mimeType(mime:APIMimeTypes)
    
    var mediaExtension : String {
        switch self {
        case .mimeType(let mime):
            return mime.rawValue
        }
    }
    
    var mime : String {
        switch self {
        case .mimeType(let mime):
            return mime.mime
        }
    }
}

enum MediaData {
    
    case Url( _:String)
    case Image( _:UIImage)
    case RawData( _:Data)
    
    var mediaData : Data? {
        switch self {
        case .Url(let strUrl):
            do {
                guard let _url = URL(string: strUrl) else { return nil}
                let data = try Data(contentsOf: _url, options: .mappedIfSafe)
                return data
            }catch{
                return nil
            }
        case .Image(let img):
            return img.toData()
        case .RawData(let data):
            return data
        }
    }
}

struct UploadMedia {
    var mediaType : MediaType
    var media : MediaData
}
