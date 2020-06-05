//
//  APIMimeTypes.swift
//  SetupApp
//
//  Copyright © 2020 mac-00020. All rights reserved.
//

import Foundation

enum APIMimeTypes : String {
    
    case jpeg = "jpeg"
    case jpg = "jpg"
    case png = "png"
    case gif = "gif"
    case svg = "svg"
    case tiff = "tiff"
    case txt = "txt"
    case pdf = "pdf"
    case m4a = "m4a"
    case mp4 = "mp4"
    case _3gp = "3gp"
    case avi = "avi"
    case mov = "mov"
    case mpg = "mpg"
    case rar = "rar"
    case jar = "jar"
    
    var mime : String {
        switch self {
        case .jpeg:
            return "image/jpeg"
        case .jpg:
            return "image/jpeg"
        case .png:
            return "image/png"
        case .gif:
            return "image/gif"
        case .svg:
            return "image/svg+xml"
        case .tiff:
            return "image/tiff"
        case .txt:
            return "text/plain"
        case .pdf:
            return "application/pdf"
        case .m4a:
            return "audio/x-m4a"
        case .mp4:
            return "video/mp4"
        case ._3gp:
            return "video/3gpp"
        case .avi:
            return "video/x-msvideo"
        case .mov:
            return "video/quicktime"
        case .mpg:
            return "video/mpeg"
        case .rar:
            return "application/x-rar-compressed"
        case .jar:
            return "application/java-archive"
            
        }
    }
}
