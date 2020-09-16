//
//  GroupOfTransparentViewController.swift
//  CoreAnimate
//
//  Created by heiyanmacmini on 2020/9/15.
//  Copyright © 2020 heiyanmacmini. All rights reserved.
//

import UIKit
/**
 UIView有一个叫做alpha的属性来确定视图的透明度。CALayer有一个等同的属性叫做opacity，这两个属性都是影响子层级的。也就是说，如果你给一个图层设置了opacity属性，那它的子图层都会受此影响。

 iOS常见的做法是把一个控件的alpha值设置为0.5（50%）以使其看上去呈现为不可用状态。对于独立的视图来说还不错，但是当一个控件有子视图的时候就有点奇怪了。

 label是一个不透明的按钮，label1是50%透明度的相同按钮。我们可以注意到，里面的标签的轮廓跟按钮的背景很不搭调。
 label1的渐隐按钮中，里面的标签清晰可见
 这是由透明度的混合叠加造成的，当你显示一个50%透明度的图层时，图层的每个像素都会一半显示自己的颜色，另一半显示图层下面的颜色。这是正常的透明度的表现。但是如果图层包含一个同样显示50%透明的子图层时，你所看到的视图，50%来自子视图，25%来了图层本身的颜色，另外的25%则来自背景色。
 */
class GroupOfTransparentViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 191 / 256, green: 191 / 256, blue: 191 / 256, alpha: 1.0)

        let btn1 = customButton()
        btn1.center = CGPoint(x: view.center.x, y: 150)
        view.addSubview(btn1)

        let btn2 = customButton()
        btn2.center = CGPoint(x: view.center.x, y: 300)
        btn2.alpha = 0.5
        view.addSubview(btn2)
        btn2.layer.shouldRasterize = true
        btn2.layer.rasterizationScale = UIScreen.main.scale
    }

    func customButton() -> UIButton {
        var frame = CGRect(x: 0, y: 0, width: 150, height: 50)
        let btn = UIButton(frame: frame)
        btn.backgroundColor = .white
        btn.layer.cornerRadius = 10

        frame = CGRect(x: 20, y: 10, width: 110, height: 30)

        let label = UILabel(frame: frame)
        label.backgroundColor = .white
        label.text = "Hello World"
        label.textAlignment = .center
        btn.addSubview(label)
        return btn
    }
}
