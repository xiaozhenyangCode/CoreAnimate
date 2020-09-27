//
//  ManualAnimationViewController.swift
//  CoreAnimate
//
//  Created by heiyanmini on 2020/9/27.
//  Copyright © 2020 heiyanmacmini. All rights reserved.
//

import UIKit
/**
 手动动画 Manual animation
 timeOffset一个很有用的功能在于你可以它可以让你手动控制动画进程，通过设置speed为0，可以禁用动画的自动播放，然后来使用timeOffset来来回显示动画序列。这可以使得运用手势来手动控制动画变得很简单。

 举个简单的例子：还是之前关门的动画，修改代码来用手势控制动画。我们给视图添加一个UIPanGestureRecognizer，然后用timeOffset左右摇晃。

 因为在动画添加到图层之后不能再做修改了，我们来通过调整layer的timeOffset达到同样的效果
 */
class ManualAnimationViewController: BaseViewController {
    var containerView: UIView!
    var doorLayer = CALayer()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 191 / 256, green: 191 / 256, blue: 191 / 256, alpha: 1.0)

        containerView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        containerView.center = view.center
        view.addSubview(containerView)

        let doorImage = UIImage(named: "door")
        doorLayer.frame = CGRect(x: 0, y: 0, width: doorImage!.size.width / 2, height: doorImage!.size.height / 2)
        doorLayer.position = CGPoint(x: 130, y: 150)
        doorLayer.contents = doorImage?.cgImage
        containerView.layer.addSublayer(doorLayer)
        let transform1 = CATransform3DMakeRotation(CGFloat(Double.pi), 0, 1, 0)
        doorLayer.transform = transform1

        let pan = UIPanGestureRecognizer(target: self, action: #selector(pan(_:)))
        view.addGestureRecognizer(pan)

        doorLayer.speed = 0

        let animation = CABasicAnimation()
        animation.keyPath = "transform.rotation.y"
        animation.toValue = Double.pi / 2
        animation.duration = 1
        doorLayer.add(animation, forKey: nil)
    }

    @objc func pan(_ pan: UIPanGestureRecognizer) {
        var x = pan.translation(in: view).x
        x /= 200

        var timeOffset = doorLayer.timeOffset
        timeOffset = min(0.999, max(0, timeOffset - Double(x)))
        doorLayer.timeOffset = timeOffset
        pan.setTranslation(.zero, in: view)
    }
}
