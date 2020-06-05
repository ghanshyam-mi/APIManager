//
//  RefreshManager.swift
//  Link4Prof
//
//  Copyright © 2019 mac-00019. All rights reserved.
//

import Foundation
import UIKit

extension UIScrollView {
    
    private static var _actionHandler: [String:((UIRefreshControl) -> Void)?] = [:]
    private var actionHandler: ((UIRefreshControl) -> Void)? {
        get {
            let tmpAddress = String.init(format: "%p", unsafeBitCast(self, to: Int.self))
            return UITableView._actionHandler[tmpAddress] ?? nil
        }
        set(newValue) {
            let tmpAddress = String.init(format: "%p", unsafeBitCast(self, to: Int.self))
            UITableView._actionHandler[tmpAddress] = newValue
        }
    }
    @discardableResult
    func addRefresher(actionHandler: ((UIRefreshControl) -> Void)?) -> UIRefreshControl{
        let refresher = UIRefreshControl()
        refresher.tintColor = UIColor.black
        refresher.addTarget(self, action: #selector(self.onRefresh(sender:)), for: .valueChanged)
        if #available(iOS 10.0, *) {
            refreshControl = refresher
        } else {
            addSubview(refresher)
        }
        self.actionHandler = actionHandler
        return refresher
    }
    
    @objc private func onRefresh(sender: UIRefreshControl) {
        guard let closure = self.actionHandler else { return }
        closure(sender)
    }
}

