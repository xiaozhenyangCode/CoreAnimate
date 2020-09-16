//
//  Func.swift
//  CoreAnimate
//
//  Created by heiyanmacmini on 2020/9/15.
//  Copyright © 2020 heiyanmacmini. All rights reserved.
//

import Foundation
import GLKit
import QuartzCore
import UIKit
/// 打印信息的宏
///
/// - Parameters:
///   - message: 打印信息
///   - fileName: 路径
///   - methodName: 方法名
///   - lineNumber: 行数
func printf<N>(_ message: N, fileName: String = #file, methodName: String = #function, lineNumber: Int = #line) {
    #if DEBUG
        print("时间:\(timeStampToString(Date()))--类名:\((fileName as NSString).lastPathComponent)--方法:\(methodName)---行号:\(lineNumber)---:\(message)")
    #else

    #endif
}

/// 随机颜色
///
/// - Returns: UIColor
func arcrandomColor() -> UIColor {
    return UIColor(red: CGFloat(arc4random() % 255) / 255, green: CGFloat(arc4random() % 255) / 255, blue: CGFloat(arc4random() % 255) / 255, alpha: 1.0)
}

func timeStampToString(_ date: Date) -> String {
    let dfmatter = DateFormatter()
    dfmatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
    return dfmatter.string(from: date)
}
