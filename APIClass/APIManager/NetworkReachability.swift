//
//  NetworkReachability.swift
//  SetupApp
//
//  Copyright © 2020 mac-00020. All rights reserved.
//

import Foundation
import Alamofire

class NetworkReachability {
    
    static let shared = NetworkReachability()
    
    var reachabilityManager :NetworkReachabilityManager?
    private(set) var isNetworkReachable = true
    
    func startMonitor() {
        
        reachabilityManager = NetworkReachabilityManager()
        reachabilityManager?.startListening(onQueue: .main, onUpdatePerforming: {  [weak self] (status) in
            guard let self = self else {return}
            switch(status){
            case .reachable(.cellular):
                self.isNetworkReachable = true
                break
            case .reachable(.ethernetOrWiFi):
                self.isNetworkReachable = true
                break
            default:
                self.isNetworkReachable = false
            }
            //self.checkReachability()
        })
    }
    
    func stop() {
        reachabilityManager?.stopListening()
        reachabilityManager = nil
    }
}

func isConnectedToInternet() ->Bool {
    return NetworkReachability.shared.isNetworkReachable
}
