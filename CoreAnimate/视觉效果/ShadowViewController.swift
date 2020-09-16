//
//  ShadowViewController.swift
//  CoreAnimate
//
//  Created by heiyanmacmini on 2020/9/15.
//  Copyright © 2020 heiyanmacmini. All rights reserved.
//

import UIKit
/**
   给shadowOpacity属性一个大于默认值（也就是0）的值，阴影就可以显示在任意图层之下。shadowOpacity是一个必须在0.0（不可见）和1.0（完全不透明）之间的浮点数。如果设置为1.0，将会显示一个有轻微模糊的黑色阴影稍微在图层之上。若要改动阴影的表现，你可以使用CALayer的另外三个属性：shadowColor，shadowOffset和shadowRadius。

   显而易见，shadowColor属性控制着阴影的颜色，和borderColor和backgroundColor一样，它的类型也是CGColorRef。阴影默认是黑色，大多数时候你需要的阴影也是黑色的（其他颜色的阴影看起来是不是有一点点奇怪。。）。

   shadowOffset属性控制着阴影的方向和距离。它是一个CGSize的值，宽度控制这阴影横向的位移，高度控制着纵向的位移。shadowOffset的默认值是 {0, -3}，意即阴影相对于Y轴有3个点的向上位移

  为什么要默认向上的阴影呢？尽管Core Animation是从图层套装演变而来（可以认为是为iOS创建的私有动画框架），但是呢，它却是在Mac OS上面世的，前面有提到，二者的Y轴是颠倒的。这就导致了默认的3个点位移的阴影是向上的。在Mac上，shadowOffset的默认值是阴影向下的，这样你就能理解为什么iOS上的阴影方向是向上的了

 苹果更倾向于用户界面的阴影应该是垂直向下的，所以在iOS把阴影宽度设为0，然后高度设为一个正值不失为一个做法。

 shadowRadius属性控制着阴影的模糊度，当它的值是0的时候，阴影就和视图一样有一个非常确定的边界线。当值越来越大的时候，边界线看上去就会越来越模糊和自然。苹果自家的应用设计更偏向于自然的阴影，所以一个非零值再合适不过了。

 通常来讲，如果你想让视图或控件非常醒目独立于背景之外（比如弹出框遮罩层），你就应该给shadowRadius设置一个稍大的值。阴影越模糊，图层的深度看上去就会更明显
                              */

/**
 maskToBounds属性裁剪掉了阴影和内容
 从技术角度来说，这个结果是可以是可以理解的，但确实又不是我们想要的效果。如果你想沿着内容裁切，你需要用到两个图层：一个只画阴影的空的外图层，和一个用masksToBounds裁剪内容的内图层
   如果我们把之前项目的右边用单独的视图把裁剪的视图包起来，我们就可以解决这个问题

 */
class ShadowViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 191 / 256, green: 191 / 256, blue: 191 / 256, alpha: 1.0)

        let shadowView = UIView(frame: CGRect(x: 100, y: 100, width: 200, height: 200))
        view.addSubview(shadowView)
        shadowView.backgroundColor = .white
        shadowView.layer.shadowOpacity = 1
        shadowView.layer.shadowOffset = CGSize(width: 3, height: 3)
        shadowView.layer.shadowRadius = 50
//        shadowView.layer.cornerRadius = 10

        let layerView3 = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        layerView3.backgroundColor = .red
        layerView3.layer.masksToBounds = true
        layerView3.layer.cornerRadius = 20

        let layerView4 = UIView(frame: CGRect(x: 50, y: 50, width: 200, height: 200))
        layerView4.backgroundColor = .blue
        layerView4.layer.cornerRadius = 20
        layerView3.addSubview(layerView4)

        layerView3.layer.borderWidth = 5
        layerView4.layer.borderWidth = 5

        let layerView2 = UIView(frame: CGRect(x: 100, y: shadowView.frame.maxY + 20, width: 200, height: 200))
        layerView2.backgroundColor = .red
        layerView2.layer.cornerRadius = 20
        view.addSubview(layerView2)

        layerView2.addSubview(layerView3)
        layerView2.layer.shadowOpacity = 1
        layerView2.layer.shadowOffset = CGSize(width: 3, height: 3)
        layerView2.layer.shadowRadius = 50
    }
}
