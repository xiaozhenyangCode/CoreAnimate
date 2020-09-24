//
//  CancelAnimationViewController.swift
//  CoreAnimate
//
//  Created by heiyanmini on 2020/9/24.
//  Copyright © 2020 heiyanmacmini. All rights reserved.
//

import UIKit
/**
 在动画过程中取消动画

 之前提到过，你可以用-addAnimation:forKey:方法中的key参数来在添加动画之后检索一个动画，使用如下方法：

 - (CAAnimation *)animationForKey:(NSString *)key;

 但并不支持在动画运行过程中修改动画，所以这个方法主要用来检测动画的属性，或者判断它是否被添加到当前图层中。

 为了终止一个指定的动画，你可以用如下方法把它从图层移除掉：

 - (void)removeAnimationForKey:(NSString *)key;
 或者移除所有动画：

 - (void)removeAllAnimations;

 动画一旦被移除，图层的外观就立刻更新到当前的模型图层的值。一般说来，动画在结束之后被自动移除，除非设置removedOnCompletion为NO，如果你设置动画在结束之后不被自动移除，那么当它不需要的时候你要手动移除它；否则它会一直存在于内存中，直到图层被销毁。
 我们来扩展之前旋转飞船的示例，这里添加一个按钮来停止或者启动动画。这一次我们用一个非nil的值作为动画的键，以便之后可以移除它。-animationDidStop:finished:方法中的flag参数表明了动画是自然结束还是被打断，我们可以在控制台打印出来。如果你用停止按钮来终止动画，它会打印NO，如果允许它完成，它会打印YES。
 */
class CancelAnimationViewController: BaseViewController, CAAnimationDelegate {
    var containerView: UIView!
    var appleLayer = CALayer()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 191 / 256, green: 191 / 256, blue: 191 / 256, alpha: 1.0)

        containerView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        containerView.center = view.center
        view.addSubview(containerView)

        appleLayer = CALayer()
        appleLayer.frame = CGRect(x: 0, y: 0, width: 128, height: 128)
        appleLayer.position = CGPoint(x: 100, y: 150)
        appleLayer.contents = UIImage(named: "zero")?.cgImage
        containerView.layer.addSublayer(appleLayer)

        let start = UIButton(frame: CGRect(x: 50, y: 300, width: 110, height: 30))
        start.setTitle("Start", for: .normal)
        start.setTitleColor(.blue, for: .normal)
        start.titleLabel?.font = .boldSystemFont(ofSize: 15)
        start.layer.cornerRadius = 10
        start.layer.shadowOpacity = 0.1
        start.backgroundColor = .white
        start.addTarget(self, action: #selector(startBtnClick), for: .touchUpInside)
        view.addSubview(start)

        let stop = UIButton(frame: CGRect(x: 250, y: 300, width: 110, height: 30))
        stop.setTitle("Stop", for: .normal)
        stop.setTitleColor(.white, for: .normal)
        stop.titleLabel?.font = .boldSystemFont(ofSize: 15)
        stop.layer.cornerRadius = 10
        stop.layer.shadowOpacity = 0.1
        stop.backgroundColor = .blue
        stop.addTarget(self, action: #selector(stopBtnClick), for: .touchUpInside)
        view.addSubview(stop)
    }

    @objc func stopBtnClick() {
        appleLayer.removeAnimation(forKey: "rotateAnimation")
    }

    @objc func startBtnClick() {
        let animation = CABasicAnimation()
        animation.keyPath = "transform.rotation"
        animation.duration = 2
        animation.delegate = self
        animation.byValue = Double.pi * 2
        appleLayer.add(animation, forKey: "rotateAnimation")
    }

    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        printf(flag)
    }
}
