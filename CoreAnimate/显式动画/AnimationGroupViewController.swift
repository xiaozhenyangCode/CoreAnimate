//
//  AnimationGroupViewController.swift
//  CoreAnimate
//
//  Created by heiyanmini on 2020/9/22.
//  Copyright © 2020 heiyanmacmini. All rights reserved.
//

import UIKit
/**
 动画组 Animation Group
 CABasicAnimation和CAKeyframeAnimation仅仅作用于单独的属性，而CAAnimationGroup可以把这些动画组合在一起。CAAnimationGroup是另一个继承于CAAnimation的子类，它添加了一个animations数组的属性，用来组合别的动画。
 */
class AnimationGroupViewController: BaseViewController {
    var groupAnimation = CAAnimationGroup()
    var colorLayer = CALayer()

    override func viewDidLoad() {
        super.viewDidLoad()
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        containerView.center = view.center
        view.addSubview(containerView)

        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 0, y: 150))
        bezierPath.addCurve(to: CGPoint(x: 200, y: 150), controlPoint1: CGPoint(x: 71, y: 0), controlPoint2: CGPoint(x: 30, y: 300))

        let pathLayer = CAShapeLayer()
        pathLayer.path = bezierPath.cgPath
        pathLayer.fillColor = UIColor.clear.cgColor
        pathLayer.strokeColor = UIColor.red.cgColor
        pathLayer.lineWidth = 3
        containerView.layer.addSublayer(pathLayer)

        colorLayer = CALayer()
        colorLayer.frame = CGRect(x: 0, y: 0, width: 64, height: 64)
        colorLayer.position = CGPoint(x: 0, y: 150)
        colorLayer.backgroundColor = arcrandomColor().cgColor
        containerView.layer.addSublayer(colorLayer)

        let anomation1 = CAKeyframeAnimation()
        anomation1.keyPath = "position"
        anomation1.path = bezierPath.cgPath
        anomation1.rotationMode = .rotateAuto

        let animation2 = CABasicAnimation()
        animation2.keyPath = "backgroundColor"
        animation2.toValue = arcrandomColor().cgColor

        groupAnimation.animations = [anomation1, animation2]
        groupAnimation.duration = 3
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        colorLayer.add(groupAnimation, forKey: nil)
    }
}
