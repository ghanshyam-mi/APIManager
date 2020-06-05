//
//  APIManager.swift
//  Tomato
//
//  Copyright © 2019 mac-00020. All rights reserved.
//

import Foundation
import Alamofire


struct APIResposne {
    
    var message: String
    var fullResponse: [String: Any]
    var statusCode : Int
    var status: HTTPStatusCode.ResponseType {
        return HTTPStatusCode(rawValue: self.statusCode)?.responseType ?? .undefined
    }
    
    fileprivate static func getSuccessObject(dict: [String: Any], statusCode:Int) -> APIResposne {
        
        /*var statusCode = dict["status"] as? Int ?? 0
         if !(400 ... 500).contains(statusCode) {
         statusCode = 200
         }*/
        let msg = dict["message"] as? String ?? ""
        return APIResposne(message: msg, fullResponse: dict, statusCode: statusCode)
    }
    
    fileprivate static func getErrorObject(error: Error, status : Int) -> APIResposne {
        return APIResposne(message: error.localizedDescription ,fullResponse: [:], statusCode: status)
    }
}

class APIManager {
    
    private init() {
    }
    lazy var AFSession: Session = {
        let rootQueue = DispatchQueue(label: "org.alamofire.sessionManager.rootQueue")
        let delegateQueue = OperationQueue()
        delegateQueue.maxConcurrentOperationCount = 1
        delegateQueue.underlyingQueue = rootQueue
        delegateQueue.name = Bundle.main.infoDictionary?["CFBundleName"] as? String ?? "appName"
        let bundleId = Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String ?? "com.task.background"
        let sessionDelegate = SessionDelegate.init(fileManager: FileManager.default)
        
        let urlSession = URLSession.init(configuration: URLSessionConfiguration.background(withIdentifier: bundleId), delegate: SessionDelegate(), delegateQueue: delegateQueue)
        return Session.init(session: urlSession, delegate: sessionDelegate, rootQueue: rootQueue)
    }()
    static let shared = APIManager()
    
    var headers: HTTPHeaders = [
        "Accept" : "application/json",
        "Authorization" : ""
    ]
    
    @discardableResult
    func request(request:APIRequest, responseHandler: @escaping (APIResposne)->Void) -> DataRequest?{
        
        let apiURL = request.apiName.name
        
        return AF.request(apiURL, method: request.method, parameters: request.params , encoding: request.encodingType.type, headers: headers).responseJSON { (response) in
            
            print("METHOD..: \(request.method.rawValue)")
            print("URL.....: \(apiURL)")
            print("STATUS..: \(response.response?.statusCode ?? 0)")
            print("BODY....: \(request.params.toJson())")
            
            let statusCode = response.response?.statusCode ?? 200
            switch response.result {
            case .success(let data):
                guard let dict = data as? [String: Any] else {
                    responseHandler(APIResposne(message:  "Invalid JSON.", fullResponse: [:], statusCode: statusCode))
                    return
                }
                DispatchQueue.main.async {
                    responseHandler(APIResposne.getSuccessObject(dict: dict, statusCode: statusCode))
                }
            case .failure(let error):
                print("Error : \(error.errorDescription ?? "N/A")")
                responseHandler(APIResposne.getErrorObject(error: error, status: response.response?.statusCode ?? -100))
            }
            
            request.isRequestRunning = false
        }
    }
    
    func requestWithImage(request:APIImageRequest, responseHandler: @escaping (APIResposne)->Void) {
        
        let apiURL = request.apiName.name
        
        let uploadRequest = AF.upload(
            multipartFormData: { multipartFormData in
                for (key, value) in request.params {
                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                }
                for (key, value) in request.singleImage {
                    if let data = value.media.mediaData{
                        let fileName = "\(Date().timeIntervalSince1970)." + value.mediaType.mediaExtension
                        multipartFormData.append(data, withName: key, fileName: fileName, mimeType:value.mediaType.mime)
                    }
                }
        },
            to: apiURL, method: request.method , headers: headers)
            .response { response in
                
                print("METHOD..: \(request.method.rawValue)")
                print("URL.....: \(apiURL)")
                print("BODY....: \(request.params.toJson())")
                if let error = response.error {
                    request.isRequestRunning = false
                    responseHandler(APIResposne.getErrorObject(error: error, status: response.response?.statusCode ?? -100))
                    return
                }
                
                do{
                    guard let jsonData = response.data else {
                        request.isRequestRunning = false
                        responseHandler(APIResposne(message:  "Invalid JSON.", fullResponse: [:], statusCode: response.response?.statusCode ?? -100))
                        return
                    }
                    
                    let parsedData = try JSONSerialization.jsonObject(with: jsonData) as? [String: Any] ?? [:]
                    
                    DispatchQueue.main.async {
                        responseHandler(APIResposne.getSuccessObject(dict: parsedData, statusCode: response.response?.statusCode ?? 200))
                    }
                    
                } catch {
                    responseHandler(APIResposne(message:  "Invalid JSON.", fullResponse: [:], statusCode: response.response?.statusCode ?? -100))
                }
        }
        uploadRequest.uploadProgress { (progress) in
            request.uploadingProgress?(progress.fractionCompleted)
        }
    }
    
    func requestWithImages(request:APIImagesRequest, responseHandler: @escaping (APIResposne)->Void) {
        
        let apiURL = request.apiName.name
        
        let uploadRequest = AF.upload(
            multipartFormData: { multipartFormData in
                for (key, value) in request.params {
                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                }
                for (key, value) in request.multipleImage {
                    for media in value {
                        if let data = media.media.mediaData{
                            let fileName = "\(Date().timeIntervalSince1970)." + media.mediaType.mediaExtension
                            multipartFormData.append(data, withName: key + "[]", fileName: fileName, mimeType:media.mediaType.mime)
                        }
                    }
                }
        },
            to: apiURL, method: request.method , headers: headers)
            .response { response in
                
                print("METHOD..: \(request.method.rawValue)")
                print("URL.....: \(apiURL)")
                print("BODY....: \(request.params.toJson())")
                if let error = response.error {
                    request.isRequestRunning = false
                    responseHandler(APIResposne.getErrorObject(error: error, status: response.response?.statusCode ?? -100))
                    return
                }
                
                do{
                    guard let jsonData = response.data else {
                        request.isRequestRunning = false
                        responseHandler(APIResposne(message:  "Invalid JSON.", fullResponse: [:], statusCode: response.response?.statusCode ?? -100))
                        return
                    }
                    
                    let parsedData = try JSONSerialization.jsonObject(with: jsonData) as? [String: Any] ?? [:]
                    
                    DispatchQueue.main.async {
                        responseHandler(APIResposne.getSuccessObject(dict: parsedData, statusCode: response.response?.statusCode ?? 200))
                    }
                    
                }catch{
                    responseHandler(APIResposne(message:  "Invalid JSON.", fullResponse: [:], statusCode: response.response?.statusCode ?? -100))
                }
        }
        uploadRequest.uploadProgress { (progress) in
            request.uploadingProgress?(progress.fractionCompleted)
        }
    }
}

