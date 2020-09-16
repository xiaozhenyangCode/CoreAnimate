//
//  LayermaskViewController.swift
//  CoreAnimate
//
//  Created by heiyanmacmini on 2020/9/15.
//  Copyright © 2020 heiyanmacmini. All rights reserved.
//

import UIKit
/**
 图层蒙板
     通过masksToBounds属性，我们可以沿边界裁剪图形；通过cornerRadius属性，我们还可以设定一个圆角。但是有时候你希望展现的内容不是在一个矩形或圆角矩形。比如，你想展示一个有星形框架的图片，又或者想让一些古卷文字慢慢渐变成背景色，而不是一个突兀的边界。
  使用一个32位有alpha通道的png图片通常是创建一个无矩形视图最方便的方法，你可以给它指定一个透明蒙板来实现。但是这个方法不能让你以编码的方式动态地生成蒙板，也不能让子图层或子视图裁剪成同样的形状。
 CALayer有一个属性叫做mask可以解决这个问题。这个属性本身就是个CALayer类型，有和其他图层一样的绘制和布局属性。它类似于一个子图层，相对于父图层（即拥有该属性的图层）布局，但是它却不是一个普通的子图层。不同于那些绘制在父图层中的子图层，mask图层定义了父图层的部分可见区域。

 mask图层的Color属性是无关紧要的，真正重要的是图层的轮廓。mask属性就像是一个饼干切割机，mask图层实心的部分会被保留下来，其他的则会被抛弃。
  如果mask图层比父图层要小，只有在mask图层里面的内容才是它关心的，除此以外的一切都会被隐藏起来。

 */
class LayermaskViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let appleImageView = UIImageView(image: UIImage(named: "safari"))
        appleImageView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        view.addSubview(appleImageView)
        appleImageView.center = view.center

        let maskLayer = CALayer()
        maskLayer.frame = appleImageView.bounds
        let androidImage = UIImage(named: "twitter")
        maskLayer.contents = androidImage?.cgImage
        appleImageView.layer.mask = maskLayer
    }
}
