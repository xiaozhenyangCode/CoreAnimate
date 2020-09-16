//
//  TransformViewController.swift
//  CoreAnimate
//
//  Created by heiyanmacmini on 2020/9/16.
//  Copyright © 2020 heiyanmacmini. All rights reserved.
//

import UIKit
/**
 仿射变换
 UIView的transform属性是一个CGAffineTransform类型，用于在二维空间做旋转，缩放和平移。CGAffineTransform是一个可以和二维空间向量（例如CGPoint）做乘法的3X2的矩阵
 用CGPoint的每一列和CGAffineTransform矩阵的每一行对应元素相乘再求和，就形成了一个新的CGPoint类型的结果。要解释一下图中显示的灰色元素，为了能让矩阵做乘法，左边矩阵的列数一定要和右边矩阵的行数个数相同，所以要给矩阵填充一些标志值，使得既可以让矩阵做乘法，又不改变运算结果，并且没必要存储这些添加的值，因为它们的值不会发生变化，但是要用来做运算。
 因此，通常会用3×3（而不是2×3）的矩阵来做二维变换，你可能会见到3行2列格式的矩阵，这是所谓的以列为主的格式。

 当对图层应用变换矩阵，图层矩形内的每一个点都被相应地做变换，从而形成一个新的四边形的形状。CGAffineTransform中的“仿射”的意思是无论变换矩阵用什么值，图层中平行的两条线在变换之后任然保持平行，CGAffineTransform可以做出任意符合上述标注的变换。

 创建一个CGAffineTransform

 对矩阵数学做一个全面的阐述就超出本书的讨论范围了，不过如果你对矩阵完全不熟悉的话，矩阵变换可能会使你感到畏惧。幸运的是，Core Graphics提供了一系列函数，对完全没有数学基础的开发者也能够简单地做一些变换。如下几个函数都创建了一个CGAffineTransform实例：

 CGAffineTransformMakeRotation(CGFloat angle)
 CGAffineTransformMakeScale(CGFloat sx, CGFloat sy)
 CGAffineTransformMakeTranslation(CGFloat tx, CGFloat ty)

 UIView可以通过设置transform属性做变换，但实际上它只是封装了内部图层的变换。

 CALayer同样也有一个transform属性，但它的类型是CATransform3D，而不是CGAffineTransform
 CALayer对应于UIView的transform属性叫做affineTransform

 混合变换

 Core Graphics提供了一系列的函数可以在一个变换的基础上做更深层次的变换，如果做一个既要缩放又要旋转的变换，这就会非常有用了。例如下面几个函数：

 CGAffineTransformRotate(CGAffineTransform t, CGFloat angle)
 CGAffineTransformScale(CGAffineTransform t, CGFloat sx, CGFloat sy)
 CGAffineTransformTranslate(CGAffineTransform t, CGFloat tx, CGFloat ty)
 当操纵一个变换的时候，初始生成一个什么都不做的变换很重要—也就是创建一个CGAffineTransform类型的空值，矩阵论中称作单位矩阵，Core Graphics同样也提供了一个方便的常量：

 CGAffineTransformIdentity
 最后，如果需要混合两个已经存在的变换矩阵，就可以使用如下方法，在两个变换的基础上创建一个新的变换：

 CGAffineTransformConcat(CGAffineTransform t1, CGAffineTransform t2);
 */
class TransformViewController: BaseViewController {
    var digitsImageView2: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let digitsImageView1 = UIImageView(image: UIImage(named: "digits"))
        view.addSubview(digitsImageView1)
        digitsImageView1.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        digitsImageView1.center = CGPoint(x: view.center.x, y: 300)

        /// 使用affineTransform对图层旋转45度
        /// 数学常量pi的倍数表示，一个pi代表180度，所以四分之一的pi就是45度。
        let transform1 = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 4))
        digitsImageView1.layer.setAffineTransform(transform1)

        digitsImageView2 = UIImageView(image: UIImage(named: "digits"))
        view.addSubview(digitsImageView2)
        digitsImageView2.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        digitsImageView2.center = CGPoint(x: view.center.x, y: 600)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /// usingSpringWithDamping的范围为0.0f到1.0f，数值越小「弹簧」的振动效果越明显。
        /// initialSpringVelocity则表示初始的速度，数值越大一开始移动越快
        UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.01, initialSpringVelocity: 5, options: .curveEaseOut, animations: {
            var transform2 = CGAffineTransform.identity
            // scale by 50%
            transform2 = transform2.scaledBy(x: 0.5, y: 0.5)
            /// rotate by 30 degrees
            transform2 = transform2.rotated(by: CGFloat(Double.pi / 180 * 30))
            /// translate by 200 points
            transform2 = transform2.translatedBy(x: 100, y: 0)
            /// apply transform to layer
            self.digitsImageView2.layer.setAffineTransform(transform2)
        }) { _ in
        }
    }
}
