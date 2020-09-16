//
//  ShapeLayerViewController.swift
//  CoreAnimate
//
//  Created by heiyanmacmini on 2020/9/16.
//  Copyright © 2020 heiyanmacmini. All rights reserved.
//

import UIKit
/**
 CAShapeLayer

 CAShapeLayer是一个通过矢量图形而不是bitmap来绘制的图层子类。你指定诸如颜色和线宽等属性，用CGPath来定义想要绘制的图形，最后CAShapeLayer就自动渲染出来了。当然，你也可以用Core Graphics直接向原始的CALyer的内容中绘制一个路径，相比直下，使用CAShapeLayer有以下一些优点：

 渲染快速。CAShapeLayer使用了硬件加速，绘制同一图形会比用Core Graphics快很多。
 高效使用内存。一个CAShapeLayer不需要像普通CALayer一样创建一个寄宿图形，所以无论有多大，都不会占用太多的内存。
 不会被图层边界剪裁掉。一个CAShapeLayer可以在边界之外绘制。你的图层路径不会像在使用Core Graphics的普通CALayer一样被剪裁掉（如我们在第二章所见）。
 不会出现像素化。当你给CAShapeLayer做3D变换时，它不像一个有寄宿图的普通图层一样变得像素化。
 创建一个CGPath

 CAShapeLayer可以用来绘制所有能够通过CGPath来表示的形状。这个形状不一定要闭合，图层路径也不一定要不可破，事实上你可以在一个图层上绘制好几个不同的形状。你可以控制一些属性比如lineWith（线宽，用点表示单位），lineCap（线条结尾的样子），和lineJoin（线条之间的结合点的样子）；但是在图层层面你只有一次机会设置这些属性。如果你想用不同颜色或风格来绘制多个形状，就不得不为每个形状准备一个图层了。

 代码用一个CAShapeLayer渲染一个简单的火柴人。CAShapeLayer属性是CGPathRef类型，但是我们用UIBezierPath帮助类创建了图层路径，这样我们就不用考虑人工释放CGPath了。图6.1是代码运行的结果。虽然还不是很完美，但是总算知道了大意对吧！
 圆角

 第二章里面提到了CAShapeLayer为创建圆角视图提供了一个方法，就是CALayer的cornerRadius属性（译者注：其实是在第四章提到的）。虽然使用CAShapeLayer类需要更多的工作，但是它有一个优势就是可以单独指定每个角。

 我们创建圆角矩形其实就是人工绘制单独的直线和弧度，但是事实上UIBezierPath有自动绘制圆角矩形的构造方法，下面这段代码绘制了一个有三个圆角一个直角的矩形：
 */
class ShapeLayerViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        containerView.center = view.center
        view.addSubview(containerView)
        containerView.layer.shadowOpacity = 0.3

        let path = UIBezierPath()
        path.addArc(withCenter: CGPoint(x: 100, y: 50), radius: 25, startAngle: 0, endAngle: CGFloat(2 * Double.pi), clockwise: true)
        path.move(to: CGPoint(x: 100, y: 75))
        path.addLine(to: CGPoint(x: 100, y: 135))
        path.move(to: CGPoint(x: 55, y: 115))
        path.addLine(to: CGPoint(x: 145, y: 115))
        path.move(to: CGPoint(x: 100, y: 135))
        path.addLine(to: CGPoint(x: 75, y: 180))
        path.move(to: CGPoint(x: 100, y: 135))
        path.addLine(to: CGPoint(x: 125, y: 180))
        let shapeLayer1 = CAShapeLayer()
        shapeLayer1.strokeColor = UIColor.red.cgColor
        shapeLayer1.fillColor = UIColor.clear.cgColor
        shapeLayer1.lineWidth = 5
        shapeLayer1.lineJoin = .round
        shapeLayer1.lineCap = .round
        shapeLayer1.path = path.cgPath
        containerView.layer.addSublayer(shapeLayer1)

        let radii = CGSize(width: 20, height: 20)
        let roundedPath = UIBezierPath(roundedRect: containerView.bounds, byRoundingCorners: [.topRight, .bottomRight, .bottomLeft, .topLeft], cornerRadii: radii)
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 5
        shapeLayer.lineJoin = .round
        shapeLayer.lineCap = .round
        shapeLayer.path = roundedPath.cgPath
        containerView.layer.addSublayer(shapeLayer)
    }
}
