//
import Foundation
//  NSObject+Extension.swift
//  CoreAnimate
//
//  Created by heiyanmacmini on 2020/9/15.
//  Copyright © 2020 heiyanmacmini. All rights reserved.
//
import UIKit
extension NSObject {
    // MARK: 返回className

    var className: String {
        let name = type(of: self).description()
        if name.contains(".") {
            return name.components(separatedBy: ".")[1]
        } else {
            return name
        }
    }

    func classFromString(_ className: String) -> BaseViewController! {
        // get the project name
        if let appName: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as! String? {
            // 拼接控制器名
            let classStringName = "\(appName).\(className)"
            // 将控制名转换为类
            let classType = NSClassFromString(classStringName) as? BaseViewController.Type
            if let type = classType {
                let newVC = type.init()
                newVC.title = className
                return newVC
            }
        }
        return nil
    }

    func classTableFromString(_ className: String) -> UITableViewController! {
        // get the project name
        if let appName: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as! String? {
            // 拼接控制器名
            let classStringName = "\(appName).\(className)"
            // 将控制名转换为类
            let classType = NSClassFromString(classStringName) as? UITableViewController.Type
            if let type = classType {
                let newVC = type.init()
                newVC.title = className
                return newVC
            }
        }
        return nil
    }
}
