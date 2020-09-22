//
//  LayerBehaviorViewController.swift
//  CoreAnimate
//
//  Created by heiyanmini on 2020/9/22.
//  Copyright © 2020 heiyanmacmini. All rights reserved.
//

import UIKit
/**
 图层行为 layer behavior
 试着直接对UIView关联的图层做动画而不是一个单独的图层。下面代码的一点修改，移除了colorLayer，并且直接设置layerView关联图层的背景色。

 运行程序，你会发现当按下按钮，图层颜色瞬间切换到新的值，而不是之前平滑过渡的动画。发生了什么呢？隐式动画好像被UIView关联图层给禁用了。

 试想一下，如果UIView的属性都有动画特性的话，那么无论在什么时候修改它，我们都应该能注意到的。所以，如果说UIKit建立在Core Animation（默认对所有东西都做动画）之上，那么隐式动画是如何被UIKit禁用掉呢？

 我们知道Core Animation通常对CALayer的所有属性（可动画的属性）做动画，但是UIView把它关联的图层的这个特性关闭了。为了更好说明这一点，我们需要知道隐式动画是如何实现的。

 我们把改变属性时CALayer自动应用的动画称作行为，当CALayer的属性被修改时候，它会调用-actionForKey:方法，传递属性的名称。剩下的操作都在CALayer的头文件中有详细的说明，实质上是如下几步：

 图层首先检测它是否有委托，并且是否实现CALayerDelegate协议指定的-actionForLayer:forKey方法。如果有，直接调用并返回结果。
 如果没有委托，或者委托没有实现-actionForLayer:forKey方法，图层接着检查包含属性名称对应行为映射的actions字典。
 如果actions字典没有包含对应的属性，那么图层接着在它的style字典接着搜索属性名。
 最后，如果在style里面也找不到对应的行为，那么图层将会直接调用定义了每个属性的标准行为的-defaultActionForKey:方法。
 所以一轮完整的搜索结束之后，-actionForKey:要么返回空（这种情况下将不会有动画发生），要么是CAAction协议对应的对象，最后CALayer拿这个结果去对先前和当前的值做动画。

 于是这就解释了UIKit是如何禁用隐式动画的：每个UIView对它关联的图层都扮演了一个委托，并且提供了-actionForLayer:forKey的实现方法。当不在一个动画块的实现中，UIView对所有图层行为返回nil，但是在动画block范围之内，它就返回了一个非空值。
 于是我们可以预言，当属性在动画块之外发生改变，UIView直接通过返回nil来禁用隐式动画。但如果在动画块范围之内，根据动画具体类型返回相应的属性，在这个例子就是CABasicAnimation（第八章“显式动画”将会提到）。

 当然返回nil并不是禁用隐式动画唯一的办法，CATransacition有个方法叫做+setDisableActions:，可以用来对所有属性打开或者关闭隐式动画。如果在清单7.2的[CATransaction begin]之后添加下面的代码，同样也会阻止动画的发生：

 [CATransaction setDisableActions:YES];

 总结一下，我们知道了如下几点

 UIView关联的图层禁用了隐式动画，对这种图层做动画的唯一办法就是使用UIView的动画函数（而不是依赖CATransaction），或者继承UIView，并覆盖-actionForLayer:forKey:方法，或者直接创建一个显式动画（具体细节见第八章）。
 对于单独存在的图层，我们可以通过实现图层的-actionForLayer:forKey:委托方法，或者提供一个actions字典来控制隐式动画。
 我们来对颜色渐变的例子使用一个不同的行为，通过给colorLayer设置一个自定义的actions字典。我们也可以使用委托来实现，但是actions字典可以写更少的代码。那么到底改如何创建一个合适的行为对象呢？

 行为通常是一个被Core Animation隐式调用的显式动画对象。这里我们使用的是一个实现了CATransaction的实例，叫做推进过渡
 */
class LayerBehaviorViewController: BaseViewController {
    var layerView: UIView!
    var colorLayer: CALayer!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 191 / 256, green: 191 / 256, blue: 191 / 256, alpha: 1.0)

        layerView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        layerView.backgroundColor = .white
        view.addSubview(layerView)
        layerView.center = view.center

        colorLayer = CALayer()
        colorLayer.frame = CGRect(x: 50, y: 50, width: 100, height: 100)
        colorLayer.backgroundColor = UIColor.blue.cgColor

        let changeBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 110, height: 30))
        changeBtn.center = CGPoint(x: view.center.x - 85, y: colorLayer.frame.maxY + 30)
        changeBtn.setTitle("Change Color", for: .normal)
        changeBtn.setTitleColor(.blue, for: .normal)
        changeBtn.titleLabel?.font = .boldSystemFont(ofSize: 15)
        changeBtn.layer.cornerRadius = 10
        changeBtn.layer.borderWidth = 1
        changeBtn.addTarget(self, action: #selector(changeBtnClick), for: .touchUpInside)
        changeBtn.layer.borderColor = UIColor.gray.cgColor
        layerView.addSubview(changeBtn)

        /// 使用推进过渡的色值动画
        let transition = CATransition()
        transition.type = .push
        transition.subtype = .fromLeft
        colorLayer.actions = ["backgroundColor": transition]
        layerView.layer.addSublayer(colorLayer)
    }

    @objc func changeBtnClick() {
        colorLayer.backgroundColor = arcrandomColor().cgColor
    }
}
