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

 多重渐变

 如果你愿意，colors属性可以包含很多颜色，所以创建一个彩虹一样的多重渐变也是很简单的。默认情况下，这些颜色在空间上均匀地被渲染，但是我们可以用locations属性来调整空间。locations属性是一个浮点数值的数组（以NSNumber包装）。这些浮点数定义了colors属性中每个不同颜色的位置，同样的，也是以单位坐标系进行标定。0.0代表着渐变的开始，1.0代表着结束。

 locations数组并不是强制要求的，但是如果你给它赋值了就一定要确保locations的数组大小和colors数组大小一定要相同，否则你将会得到一个空白的渐变。

 清单6.7展示了一个基于清单6.6的对角线渐变的代码改造。现在变成了从红到黄最后到绿色的渐变。locations数组指定了0.0，0.25和0.5三个数值，这样这三个渐变就有点像挤在了左上角
 */
class GradientLayerViewCtrl: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let containerView1 = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        view.addSubview(containerView1)
        containerView1.center = CGPoint(x: view.center.x, y: 300)

        let gradientLayer1 = CAGradientLayer()
        gradientLayer1.frame = containerView1.bounds
        containerView1.layer.addSublayer(gradientLayer1)

        gradientLayer1.colors = [UIColor.red.cgColor, UIColor.blue.cgColor]
        gradientLayer1.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer1.endPoint = CGPoint(x: 1, y: 1)

        let containerView2 = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        view.addSubview(containerView2)
        containerView2.center = CGPoint(x: view.center.x, y: containerView1.frame.maxY + 200)

        let gradientLayer2 = CAGradientLayer()
        gradientLayer2.frame = containerView2.bounds
        containerView2.layer.addSublayer(gradientLayer2)

        gradientLayer2.colors = [UIColor.red.cgColor, UIColor.blue.cgColor, UIColor.yellow.cgColor, UIColor.purple.cgColor, UIColor.orange.cgColor, UIColor.green.cgColor]
        gradientLayer2.locations = [0.1, 0.3, 0.5, 0.7, 0.9, 1.0]
        gradientLayer2.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer2.endPoint = CGPoint(x: 1, y: 1)
    }
}
