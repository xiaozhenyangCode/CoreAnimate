//
//  Proxy.swift
//  yuanshiVideo
//
//  Created by heiyanmacmini on 2020/8/18.
//  Copyright © 2020 heiyanmacmini. All rights reserved.
//

import UIKit

class Proxy: NSObject {
    weak var target: NSObjectProtocol?

    public init(_ target: NSObjectProtocol?) {
        self.target = target
        super.init()
    }

    override func responds(to aSelector: Selector!) -> Bool {
        return target?.responds(to: aSelector) == true
    }

    override func forwardingTarget(for aSelector: Selector!) -> Any? {
        if target?.responds(to: aSelector) == true {
            return target
        } else {
            return super.forwardingTarget(for: aSelector)
        }
    }
}
