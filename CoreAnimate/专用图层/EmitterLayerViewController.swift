//
//  EmitterLayerViewController.swift
//  CoreAnimate
//
//  Created by heiyanmini on 2020/9/21.
//  Copyright © 2020 heiyanmacmini. All rights reserved.
//
// Emitter 发射器
import UIKit
/**
 CAEmitterLayer
 CAEmitterLayer是一个高性能的粒子引擎，被用来创建实时例子动画如：烟雾，火，雨等等这些效果。
 CAEmitterLayer看上去像是许多CAEmitterCell的容器，这些CAEmitierCell定义了一个例子效果。你将会为不同的例子效果定义一个或多个CAEmitterCell作为模版，同时CAEmitterLayer负责基于这些模版实例化一个粒子流。一个CAEmitterCell类似于一个CALayer：它有一个contents属性可以定义为一个CGImage，另外还有一些可设置属性控制着表现和行为。我们不会对这些属性逐一进行详细的描述，你们可以在CAEmitterCell类的头文件中找到。
 CAEMitterCell的属性基本上可以分为三种：

 这种粒子的某一属性的初始值。比如，color属性指定了一个可以混合图片内容颜色的混合色。在示例中，我们将它设置为桔色。
 例子某一属性的变化范围。比如emissionRange属性的值是2π，这意味着例子可以从360度任意位置反射出来。如果指定一个小一些的值，就可以创造出一个圆锥形
 指定值在时间线上的变化。比如，在示例中，我们将alphaSpeed设置为-0.4，就是说例子的透明度每过一秒就是减少0.4，这样就有发射出去之后逐渐小时的效果
 CAEmitterLayer的属性它自己控制着整个例子系统的位置和形状。一些属性比如birthRate，lifetime和celocity，这些属性在CAEmitterCell中也有。这些属性会以相乘的方式作用在一起，这样你就可以用一个值来加速或者扩大整个例子系统。其他值得提到的属性有以下这些：

 preservesDepth，是否将3D例子系统平面化到一个图层（默认值）或者可以在3D空间中混合其他的图层
 renderMode，控制着在视觉上粒子图片是如何混合的。你可能已经注意到了示例中我们把它设置为kCAEmitterLayerAdditive，它实现了这样一个效果：合并例子重叠部分的亮度使得看上去更亮。如果我们把它设置为默认的kCAEmitterLayerUnordered，效果就没那么好看了
 */
class EmitterLayerViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        view.addSubview(containerView)
        containerView.center = view.center

        let emitter = CAEmitterLayer()
        emitter.contentsScale = UIScreen.main.scale
        emitter.frame = containerView.bounds
        emitter.renderMode = .unordered
        emitter.preservesDepth = true
        emitter.emitterPosition = CGPoint(x: emitter.frame.size.width / 2, y: emitter.frame.size.height / 2)
        containerView.layer.addSublayer(emitter)

        let cell = CAEmitterCell()
        cell.contents = UIImage(named: "apple")?.cgImage
        cell.birthRate = 150
        cell.lifetime = 5
        cell.color = UIColor.orange.cgColor
        cell.alphaSpeed = -0.4
        cell.velocity = 50
        cell.velocityRange = 50
        cell.emissionRange = CGFloat(Double.pi * 2)

        emitter.emitterCells = [cell]
    }
}
