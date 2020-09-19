//
//  GradientLayerViewCtrl.swift
//  CoreAnimate
//
//  Created by heiyanmini on 2020/9/18.
//  Copyright © 2020 heiyanmacmini. All rights reserved.
//

import UIKit
/**
 CAGradientLayer

 CAGradientLayer是用来生成两种或更多颜色平滑渐变的。用Core Graphics复制一个CAGradientLayer并将内容绘制到一个普通图层的寄宿图也是有可能的，但是CAGradientLayer的真正好处在于绘制使用了硬件加速。

 基础渐变

 我们将从一个简单的红变蓝的对角线渐变开始（.这些渐变色彩放在一个数组中，并赋给colors属性。这个数组成员接受CGColorRef类型的值（并不是从NSObject派生而来），所以我们要用通过bridge转换以确保编译正常。

 CAGradientLayer也有startPoint和endPoint属性，他们决定了渐变的方向。这两个参数是以单位坐标系进行的定义，所以左上角坐标是{0, 0}，右下角坐标是{1, 1}。
 */
class GradientLayerViewCtrl: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        view.addSubview(containerView)
        containerView.center = view.center

        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = containerView.bounds
        containerView.layer.addSublayer(gradientLayer)

        gradientLayer.colors = [UIColor.red.cgColor, UIColor.blue.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        
    }
}
