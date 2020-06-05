//
//  MDLAPIBase.swift
//  APIClass
//
//  Copyright © 2020 APIClass. All rights reserved.
//

import Foundation

struct APIBaseModel<T,M> : Codable where T : Codable, M : Codable {
    
    let data : T?
    var meta : M?
    
    enum CodingKeys: String, CodingKey {
        case data = "data"
        case meta = "meta"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent(T.self, forKey: .data)
        meta = try values.decodeIfPresent(M.self, forKey: .meta)
        if meta == nil{
            meta = try MDLMeta(from: decoder) as? M
        }
    }
    
}

struct MDLMeta : Codable {
    
    let message : String?
    let code : Int?
    
    enum CodingKeys: String, CodingKey {
        case message = "message"
        case code = "code"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        code = try values.decodeIfPresent(Int.self, forKey: .code)
    }
}

struct MDLDog : Codable {
    
    let message : String?
    private let status : String?
    var _status : Bool {
        return (status ?? "").lowercased() == "success"
    }
    enum CodingKeys: String, CodingKey {
        case message = "message"
        case status = "status"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        status = try values.decodeIfPresent(String.self, forKey: .status)
    }
}
