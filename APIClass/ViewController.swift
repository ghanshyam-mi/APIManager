//
//  ViewController.swift
//  APIClass
//
//  Created by Ghanshyam on 05/06/20.
//  Copyright © 2020 APIClass. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        showActivityIndicator()
        
        APIRequest(apiName: .RandomDog, method: .get, encodingType: .queryString).request(model: MDLDog.self) { [weak self] (request, dataModel) in
            
            hideActivityIndicator()
            guard let _ = self else { return }
            print(dataModel?.message ?? "N/A")
            //guard let arrPost = dataModel?.data else { return }
            print(request.fullResponse.toJson())
        }
        
    }
}

