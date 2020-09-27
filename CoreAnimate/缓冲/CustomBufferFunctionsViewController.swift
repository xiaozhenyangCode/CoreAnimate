//
//  CustomBufferFunctionsViewController.swift
//  CoreAnimate
//
//  Created by heiyanmini on 2020/9/27.
//  Copyright © 2020 heiyanmacmini. All rights reserved.
//

import UIKit
/**
 自定义缓冲函数

 我们给时钟项目添加了动画。看起来很赞，但是如果有合适的缓冲函数就更好了。在显示世界中，钟表指针转动的时候，通常起步很慢，然后迅速啪地一声，最后缓冲到终点。但是标准的缓冲函数在这里每一个适合它，那该如何创建一个新的呢？

 除了+functionWithName:之外，CAMediaTimingFunction同样有另一个构造函数，一个有四个浮点参数的+functionWithControlPoints::::（注意这里奇怪的语法，并没有包含具体每个参数的名称，这在objective-C中是合法的，但是却违反了苹果对方法命名的指导方针，而且看起来是一个奇怪的设计）。

 使用这个方法，我们可以创建一个自定义的缓冲函数，来匹配我们的时钟动画，为了理解如何使用这个方法，我们要了解一些CAMediaTimingFunction是如何工作的。

 三次贝塞尔曲线

 CAMediaTimingFunction函数的主要原则在于它把输入的时间转换成起点和终点之间成比例的改变。我们可以用一个简单的图标来解释，横轴代表时间，纵轴代表改变的量，于是线性的缓冲就是一条从起点开始的简单的斜线。

 这条曲线的斜率代表了速度，斜率的改变代表了加速度，原则上来说，任何加速的曲线都可以用这种图像来表示，但是CAMediaTimingFunction使用了一个叫做三次贝塞尔曲线的函数，它只可以产出指定缓冲函数的子集（我们之前在第八章中创建CAKeyframeAnimation路径的时候提到过三次贝塞尔曲线）。

 你或许会回想起，一个三次贝塞尔曲线通过四个点来定义，第一个和最后一个点代表了曲线的起点和终点，剩下中间两个点叫做控制点，因为它们控制了曲线的形状，贝塞尔曲线的控制点其实是位于曲线之外的点，也就是说曲线并不一定要穿过它们。你可以把它们想象成吸引经过它们曲线的磁铁。

 实际上它是一个很奇怪的函数，先加速，然后减速，最后快到达终点的时候又加速，那么标准的缓冲函数又该如何用图像来表示呢？

 CAMediaTimingFunction有一个叫做-getControlPointAtIndex:values:的方法，可以用来检索曲线的点，这个方法的设计的确有点奇怪（或许也就只有苹果能回答为什么不简单返回一个CGPoint），但是使用它我们可以找到标准缓冲函数的点，然后用UIBezierPath和CAShapeLayer来把它画出来。

 曲线的起始和终点始终是{0, 0}和{1, 1}，于是我们只需要检索曲线的第二个和第三个点（控制点）。

 那么对于我们自定义时钟指针的缓冲函数来说，我们需要初始微弱，然后迅速上升，最后缓冲到终点的曲线，通过一些实验之后，最终结果如下：

 [CAMediaTimingFunction functionWithControlPoints:1 :0 :0.75 :1];
 如果把它转换成缓冲函数的图像，最后如图10.4所示，如果把它添加到时钟的程序，就形成了之前一直期待的非常赞的效果。

 */
class CustomBufferFunctionsViewController: BaseViewController {
    var layerView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(red: 191 / 256, green: 191 / 256, blue: 191 / 256, alpha: 1.0)

        layerView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        layerView.backgroundColor = .white
        layerView.center = view.center
        view.addSubview(layerView)

        let function = CAMediaTimingFunction(name: .easeInEaseOut)

        let controlPoint1 = UnsafeMutablePointer<Float>.allocate(capacity: 1)
        let controlPoint2 = UnsafeMutablePointer<Float>.allocate(capacity: 1)

        function.getControlPoint(at: 1, values: controlPoint1)
        function.getControlPoint(at: 2, values: controlPoint2)

        let point1 = CGPoint(x: CGFloat(controlPoint1[0]), y: CGFloat(controlPoint1[1]))
        let point2 = CGPoint(x: CGFloat(controlPoint2[0]), y: CGFloat(controlPoint2[1]))

        let path = UIBezierPath()
        path.move(to: .zero)
        path.addCurve(to: CGPoint(x: 1, y: 1), controlPoint1: point1, controlPoint2: point2)
        path.apply(CGAffineTransform(scaleX: 200, y: 200))

        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 4
        shapeLayer.path = path.cgPath
        layerView.layer.addSublayer(shapeLayer)
        layerView.layer.isGeometryFlipped = true
    }
}
