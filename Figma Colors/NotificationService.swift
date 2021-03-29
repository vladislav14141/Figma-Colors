//
//  NotificationService.swift
//  RST-PMS
//
//  Created by Миронов Влад on 10.08.2020.
//  Copyright © 2020 RST-TUR, OOO. All rights reserved.
//

import Foundation
import Combine
enum Notifications: String {
    
    case showCode
}

extension Notifications {
    private var name: String {
        return rawValue
    }
    
    private var notification: Notification.Name {
        return Notification.Name(name)
    }
    
    func post(_ object: Any? = nil) {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: self.notification, object: object)
        }
    }
    
    func observe(observe observer: Any, execute selector: Selector) {
        NotificationCenter.default.addObserver(observer, selector: selector, name: notification, object: nil)
    }
    
    func publisher() -> NotificationCenter.Publisher {
        return NotificationCenter.default.publisher(for: notification)
    }
    
    static func postSome(_ types: [Notifications]) {
        types.forEach({
            $0.post()
        })
    }
}



