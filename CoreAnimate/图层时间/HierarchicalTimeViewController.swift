//
//  HierarchicalTimeViewController.swift
//  CoreAnimate
//
//  Created by heiyanmini on 2020/9/25.
//  Copyright © 2020 heiyanmacmini. All rights reserved.
//

import UIKit
/**
 层级关系时间 Hierarchical time
 在第三章“图层几何学”中，你已经了解到每个图层是如何相对在图层树中的父图层定义它的坐标系的。动画时间和它类似，每个动画和图层在时间上都有它自己的层级概念，相对于它的父亲来测量。对图层调整时间将会影响到它本身和子图层的动画，但不会影响到父图层。另一个相似点是所有的动画都被按照层级组合（使用CAAnimationGroup实例）。

 对CALayer或者CAGroupAnimation调整duration和repeatCount/repeatDuration属性并不会影响到子动画。但是beginTime，timeOffset和speed属性将会影响到子动画。然而在层级关系中，beginTime指定了父图层开始动画（或者组合关系中的父动画）和对象将要开始自己动画之间的偏移。类似的，调整CALayer和CAGroupAnimation的speed属性将会对动画以及子动画速度应用一个缩放的因子。

 全局时间和本地时间

 CoreAnimation有一个全局时间的概念，也就是所谓的马赫时间（“马赫”实际上是iOS和Mac OS系统内核的命名）。马赫时间在设备上所有进程都是全局的—但是在不同设备上并不是全局的—不过这已经足够对动画的参考点提供便利了，你可以使用CACurrentMediaTime函数来访问马赫时间：

 CFTimeInterval time = CACurrentMediaTime();
 这个函数返回的值其实无关紧要（它返回了设备自从上次启动后的秒数，并不是你所关心的），它真实的作用在于对动画的时间测量提供了一个相对值。注意当设备休眠的时候马赫时间会暂停，也就是所有的CAAnimations（基于马赫时间）同样也会暂停。

 因此马赫时间对长时间测量并不有用。比如用CACurrentMediaTime去更新一个实时闹钟并不明智。（可以用[NSDate date]代替，就像第三章例子所示）。

 每个CALayer和CAAnimation实例都有自己本地时间的概念，是根据父图层/动画层级关系中的beginTime，timeOffset和speed属性计算。就和转换不同图层之间坐标关系一样，CALayer同样也提供了方法来转换不同图层之间的本地时间。如下：

 - (CFTimeInterval)convertTime:(CFTimeInterval)t fromLayer:(CALayer *)l;
 - (CFTimeInterval)convertTime:(CFTimeInterval)t toLayer:(CALayer *)l;
 当用来同步不同图层之间有不同的speed，timeOffset和beginTime的动画，这些方法会很有用。

 暂停，倒回和快进

 设置动画的speed属性为0可以暂停动画，但在动画被添加到图层之后不太可能再修改它了，所以不能对正在进行的动画使用这个属性。给图层添加一个CAAnimation实际上是给动画对象做了一个不可改变的拷贝，所以对原始动画对象属性的改变对真实的动画并没有作用。相反，直接用-animationForKey:来检索图层正在进行的动画可以返回正确的动画对象，但是修改它的属性将会抛出异常。

 如果移除图层正在进行的动画，图层将会急速返回动画之前的状态。但如果在动画移除之前拷贝呈现图层到模型图层，动画将会看起来暂停在那里。但是不好的地方在于之后就不能再恢复动画了。

 一个简单的方法是可以利用CAMediaTiming来暂停图层本身。如果把图层的speed设置成0，它会暂停任何添加到图层上的动画。类似的，设置speed大于1.0将会快进，设置成一个负值将会倒回动画。

 通过增加主窗口图层的speed，可以暂停整个应用程序的动画。这对UI自动化提供了好处，我们可以加速所有的视图动画来进行自动化测试（注意对于在主窗口之外的视图并不会被影响，比如UIAlertview）。可以在app delegate设置如下进行验证：

 self.window.layer.speed = 100;
 你也可以通过这种方式来减速，但其实也可以在模拟器通过切换慢速动画来实现。
 */
class HierarchicalTimeViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
