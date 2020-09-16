//
//  ShadowPathViewController.swift
//  CoreAnimate
//
//  Created by heiyanmacmini on 2020/9/15.
//  Copyright © 2020 heiyanmacmini. All rights reserved.
//

import UIKit
/**
 shadowPath属性

 我们已经知道图层阴影并不总是方的，而是从图层内容的形状继承而来。这看上去不错，但是实时计算阴影也是一个非常消耗资源的，尤其是图层有多个子图层，每个图层还有一个有透明效果的寄宿图的时候。

 如果你事先知道你的阴影形状会是什么样子的，你可以通过指定一个shadowPath来提高性能。shadowPath是一个CGPathRef类型（一个指向CGPath的指针）。CGPath是一个Core Graphics对象，用来指定任意的一个矢量图形。我们可以通过这个属性单独于图层形状之外指定阴影的形状
 */
class ShadowPathViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let squarePathImageView = UIImageView(image: UIImage(named: "fengche"))
        squarePathImageView.frame = CGRect(x: 100, y: 150, width: 100, height: 170)
        view.addSubview(squarePathImageView)
        squarePathImageView.layer.shadowOpacity = 0.4

        let squarePath = CGMutablePath()
        squarePath.addRect(squarePathImageView.bounds)
        squarePathImageView.layer.shadowPath = squarePath

        let circlePathImageView = UIImageView(image: UIImage(named: "fengche"))
        circlePathImageView.frame = CGRect(x: 100, y: squarePathImageView.frame.maxY + 50, width: 100, height: 170)
        view.addSubview(circlePathImageView)
        circlePathImageView.layer.shadowOpacity = 0.4

        let circlePath = CGMutablePath()
        circlePath.addEllipse(in: circlePathImageView.bounds)
        circlePathImageView.layer.shadowPath = circlePath
    }
}
