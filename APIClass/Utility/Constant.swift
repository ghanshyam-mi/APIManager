//
//  Constant.swift
//  APIClass
//
//  Copyright © 2020 APIClass. All rights reserved.
//

import Foundation
import NVActivityIndicatorView

func showActivityIndicator() {
    DispatchQueue.main.async {
        let activityData = ActivityData()
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
    }
}

func hideActivityIndicator() {
    DispatchQueue.main.async {
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
    }
}
