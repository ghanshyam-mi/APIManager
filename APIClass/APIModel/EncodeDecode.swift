//
//  EncodeDecode.swift
//  APIClass
//
//  Copyright © 2020 APIClass. All rights reserved.
//

import Foundation
import UIKit

extension Collection {
    
    func toData() throws -> Data {
        return try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
    }
    
    func parseResponse<T: Encodable>() -> T? where T: Decodable {
        
        func parseData<T: Encodable,M:Collection>(response:M) -> T? where T: Decodable {
            do {
                return try response.toData().decoded()
            } catch {
                print(error)
                return nil
            }
        }
        return parseData(response: self)
    }
    
    func toJson() -> String {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: [.prettyPrinted])
            guard let jsonString = String(data: jsonData, encoding: String.Encoding.utf8) else {
                print("Can't create string with data.")
                return "{}"
            }
            return jsonString
        } catch let parseError {
            print("json serialization error: \(parseError)")
            return "{}"
        }
    }
}

extension Data {
    
    func decoded<T: Decodable>() throws -> T {
        return try JSONDecoder().decode(T.self,from:self)
    }
}

extension UIImage {
    
    func toData() -> Data? {
        return self.jpegData(compressionQuality: 1.0)
    }
}
