//
//  BufferKeyFramesViewController.swift
//  CoreAnimate
//
//  Created by heiyanmini on 2020/9/27.
//  Copyright © 2020 heiyanmacmini. All rights reserved.
//

import UIKit
/**
 更加复杂的动画曲线

 考虑一个橡胶球掉落到坚硬的地面的场景，当开始下落的时候，它会持续加速知道落到地面，然后经过几次反弹，最后停下来。

 这种效果没法用一个简单的三次贝塞尔曲线表示，于是不能用CAMediaTimingFunction来完成。但如果想要实现这样的效果，可以用如下几种方法：

 用CAKeyframeAnimation创建一个动画，然后分割成几个步骤，每个小步骤使用自己的计时函数（具体下节介绍）。
 使用定时器逐帧更新实现动画（见第11章，“基于定时器的动画”）。
 基于关键帧的缓冲

 为了使用关键帧实现反弹动画，我们需要在缓冲曲线中对每一个显著的点创建一个关键帧（在这个情况下，关键点也就是每次反弹的峰值），然后应用缓冲函数把每段曲线连接起来。同时，我们也需要通过keyTimes来指定每个关键帧的时间偏移，由于每次反弹的时间都会减少，于是关键帧并不会均匀分布。

 这种方式还算不错，但是实现起来略显笨重（因为要不停地尝试计算各种关键帧和时间偏移）并且和动画强绑定了（因为如果要改变动画的一个属性，那就意味着要重新计算所有的关键帧）。那该如何写一个方法，用缓冲函数来把任何简单的属性动画转换成关键帧动画呢，下面我们来实现它。

 流程自动化

 在清单10.6中，我们把动画分割成相当大的几块，然后用Core Animation的缓冲进入和缓冲退出函数来大约形成我们想要的曲线。但如果我们把动画分割成更小的几部分，那么我们就可以用直线来拼接这些曲线（也就是线性缓冲）。为了实现自动化，我们需要知道如何做如下两件事情：

 自动把任意属性动画分割成多个关键帧
 用一个数学函数表示弹性动画，使得可以对帧做便宜
 为了解决第一个问题，我们需要复制Core Animation的插值机制。这是一个传入起点和终点，然后在这两个点之间指定时间点产出一个新点的机制。对于简单的浮点起始值，公式如下（假设时间从0到1）：

 value = (endValue – startValue) × time + startValue;
 那么如果要插入一个类似于CGPoint，CGColorRef或者CATransform3D这种更加复杂类型的值，我们可以简单地对每个独立的元素应用这个方法（也就CGPoint中的x和y值，CGColorRef中的红，蓝，绿，透明值，或者是CATransform3D中独立矩阵的坐标）。我们同样需要一些逻辑在插值之前对对象拆解值，然后在插值之后在重新封装成对象，也就是说需要实时地检查类型。
 一旦我们可以用代码获取属性动画的起始值之间的任意插值，我们就可以把动画分割成许多独立的关键帧，然后产出一个线性的关键帧动画。
 注意到我们用了60 x 动画时间（秒做单位）作为关键帧的个数，这时因为Core Animation按照每秒60帧去渲染屏幕更新，所以如果我们每秒生成60个关键帧，就可以保证动画足够的平滑（尽管实际上很可能用更少的帧率就可以达到很好的效果）。

 我们在示例中仅仅引入了对CGPoint类型的插值代码。但是，从代码中很清楚能看出如何扩展成支持别的类型。作为不能识别类型的备选方案，我们仅仅在前一半返回了fromValue，在后一半返回了toValue。

 这可以起到作用，但效果并不是很好，到目前为止我们所完成的只是一个非常复杂的方式来使用线性缓冲复制CABasicAnimation的行为。这种方式的好处在于我们可以更加精确地控制缓冲，这也意味着我们可以应用一个完全定制的缓冲函数。那么该如何做呢？

 缓冲背后的数学并不很简单，但是幸运的是我们不需要一一实现它。罗伯特·彭纳有一个网页关于缓冲函数（http://www.robertpenner.com/easing），包含了大多数普遍的缓冲函数的多种编程语言的实现的链接，包括C。这里是一个缓冲进入缓冲退出函数的示例（实际上有很多不同的方式去实现它）。
 */
class BufferKeyFramesViewController: BaseViewController, CAAnimationDelegate {
    var containerView: UIView!
    var ballImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 191 / 256, green: 191 / 256, blue: 191 / 256, alpha: 1.0)

        containerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width))
        containerView.center = view.center
        containerView.backgroundColor = .white
        view.addSubview(containerView)

        ballImageView = UIImageView(image: UIImage(named: "ball"))
        ballImageView.center = CGPoint(x: view.center.x, y: 70)
        containerView.addSubview(ballImageView)
    }

    func animate() {
        var frames = [NSValue]()
        ballImageView.center = CGPoint(x: view.center.x, y: 70)

        let fromValue = NSValue(cgPoint: CGPoint(x: view.center.x, y: 70))
        let toValue = NSValue(cgPoint: CGPoint(x: view.center.x, y: 268))
        let duration = 1
        let numFrames = duration * 60
        for index in 0 ... numFrames {
            var time = 1 / Float(numFrames) * Float(index)
            time = bounceEaseOut(time)
            frames.append(interpolateFromValue(fromValue, toValue, time))
        }

        let animation = CAKeyframeAnimation()
        animation.keyPath = "position"
        animation.duration = 1.5
        animation.delegate = self
        animation.values = frames
        ballImageView.layer.add(animation, forKey: nil)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        animate()
    }

    func interpolateFromValue(_ fromValue: NSValue, _ toValue: NSValue, _ time: Float) -> NSValue {
        let fromPoint = fromValue.cgPointValue
        let toPoint = toValue.cgPointValue
        let result = CGPoint(x: interpolate(fromPoint.x, toPoint.x, CGFloat(time)), y: interpolate(fromPoint.y, toPoint.y, CGFloat(time)))
        return NSValue(cgPoint: result)
    }

    func interpolate(_ from: CGFloat, _ to: CGFloat, _ time: CGFloat) -> CGFloat {
        return (to - from) * time + from
    }

    func quadraticEaseInOut(_ t: Float) -> Float {
        let a = (2 * t * t)
        let b = (-2 * t * t) + (4 * t) - 1
        return (t < 0.5) ? a : b
    }

    func bounceEaseOut(_ t: Float) -> Float {
        if t < 4 / 11 {
            return 121 * t * t / 16
        } else if t < 8 / 11 {
            return (363 / 40 * t * t) - (99 / 10 * t) + 17 / 5
        } else if t < 9 / 10 {
            return (4356 / 361 * t * t) - (35442 / 1805 * t) + 16061 / 1805
        }
        return (54 / 5 * t * t) - (513 / 25 * t) + 268 / 25
    }
}
