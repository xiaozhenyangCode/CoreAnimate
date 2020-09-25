//
//  CAMediaTimingViewController.swift
//  CoreAnimate
//
//  Created by heiyanmini on 2020/9/24.
//  Copyright © 2020 heiyanmacmini. All rights reserved.
//

import UIKit
/**
 CAMediaTiming协议

 CAMediaTiming协议定义了在一段动画内用来控制逝去时间的属性的集合，CALayer和CAAnimation都实现了这个协议，所以时间可以被任意基于一个图层或者一段动画的类控制。
 持续和重复

 我们在第八章“显式动画”中简单提到过duration（CAMediaTiming的属性之一），duration是一个CFTimeInterval的类型（类似于NSTimeInterval的一种双精度浮点类型），对将要进行的动画的一次迭代指定了时间。

 这里的一次迭代是什么意思呢？CAMediaTiming另外还有一个属性叫做repeatCount，代表动画重复的迭代次数。如果duration是2，repeatCount设为3.5（三个半迭代），那么完整的动画时长将是7秒。

 duration和repeatCount默认都是0。但这不意味着动画时长为0秒，或者0次，这里的0仅仅代表了“默认”，也就是0.25秒和1次，你可以用一个简单的测试来尝试为这两个属性赋多个值，
 创建重复动画的另一种方式是使用repeatDuration属性，它让动画重复一个指定的时间，而不是指定次数。你甚至设置一个叫做autoreverses的属性（BOOL类型）在每次间隔交替循环过程中自动回放。这对于播放一段连续非循环的动画很有用，例如打开一扇门，然后关上它。

 */
class CAMediaTimingViewController: BaseViewController, CAAnimationDelegate {
    var appleLayer = CALayer()
    var containerView: UIView!
    var durationField: UITextField!
    var repeatField: UITextField!
    var start: UIButton!
    var doorLayer = CALayer()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 191 / 256, green: 191 / 256, blue: 191 / 256, alpha: 1.0)

        containerView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        containerView.center = view.center
        view.addSubview(containerView)

        appleLayer.frame = CGRect(x: 0, y: 0, width: 128, height: 128)
        appleLayer.position = CGPoint(x: 20, y: 150)
        appleLayer.contents = UIImage(named: "ship")?.cgImage
        containerView.layer.addSublayer(appleLayer)

        doorLayer.frame = CGRect(x: 0, y: 0, width: 128, height: 128)
        doorLayer.position = CGPoint(x: 200, y: 150)
        doorLayer.contents = UIImage(named: "door")?.cgImage
        containerView.layer.addSublayer(doorLayer)
        let transform1 = CATransform3DMakeRotation(CGFloat(Double.pi), 0, 1, 0)
        doorLayer.transform = transform1

        durationField = UITextField(frame: CGRect(x: 50, y: 300, width: 110, height: 30))
        durationField.layer.cornerRadius = 10
        durationField.placeholder = "duration"
        durationField.layer.shadowOpacity = 0.1
        durationField.backgroundColor = .white
        view.addSubview(durationField)

        repeatField = UITextField(frame: CGRect(x: 250, y: 300, width: 110, height: 30))
        repeatField.layer.cornerRadius = 10
        repeatField.layer.shadowOpacity = 0.1
        repeatField.placeholder = "repeatCount"
        repeatField.backgroundColor = .white
        view.addSubview(repeatField)

        start = UIButton(frame: CGRect(x: 130, y: view.frame.height - 200, width: 110, height: 30))
        start.setTitle("Start", for: .normal)
        start.setTitleColor(.blue, for: .normal)
        start.titleLabel?.font = .boldSystemFont(ofSize: 15)
        start.layer.cornerRadius = 10
        start.layer.shadowOpacity = 0.1
        start.backgroundColor = .white
        start.addTarget(self, action: #selector(startBtnClick), for: .touchUpInside)
        view.addSubview(start)

        let telativeTime = UIButton(frame: CGRect(x: 130, y: view.frame.height - 150, width: 110, height: 30))
        telativeTime.setTitle("Relative time", for: .normal)
        telativeTime.setTitleColor(.blue, for: .normal)
        telativeTime.titleLabel?.font = .boldSystemFont(ofSize: 15)
        telativeTime.layer.cornerRadius = 10
        telativeTime.layer.shadowOpacity = 0.1
        telativeTime.backgroundColor = .white
        telativeTime.addTarget(self, action: #selector(telativeTimeBtnClick), for: .touchUpInside)
        view.addSubview(telativeTime)
    }

    @objc func startBtnClick() {
        let animation = CABasicAnimation()
        animation.keyPath = "transform.rotation"
        animation.duration = CFTimeInterval(durationField.text!) ?? 0
        animation.repeatCount = Float(repeatField.text!) ?? 0
        animation.delegate = self
        animation.autoreverses = true
        animation.byValue = Double.pi * 2
        appleLayer.add(animation, forKey: "rotateAnimation")
        setControlsEnabled(false)

        var perspective = CATransform3DIdentity
        perspective.m34 = -1 / 500
        containerView.layer.sublayerTransform = perspective

        let doorAnimation = CABasicAnimation()
        doorAnimation.keyPath = "transform.rotation.y"
        doorAnimation.repeatDuration = CFTimeInterval(Float.infinity)
        doorAnimation.delegate = self
        doorAnimation.duration = 2
        doorAnimation.autoreverses = true
        doorAnimation.byValue = Double.pi / 2
        doorLayer.add(doorAnimation, forKey: nil)
    }

    func setControlsEnabled(_ enabled: Bool) {
        for item in [durationField, repeatField, start] {
            item?.isEnabled = enabled
            item?.alpha = enabled ? 1.0 : 0.25
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        durationField.resignFirstResponder()
        repeatField.resignFirstResponder()
    }

    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        setControlsEnabled(true)
    }

    @objc func telativeTimeBtnClick() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let ctrl = storyBoard.instantiateViewController(withIdentifier: "RelativeTimeViewController")
        navigationController?.pushViewController(ctrl, animated: true)
    }
}

/**

 相对时间

 每次讨论到Core Animation，时间都是相对的，每个动画都有它自己描述的时间，可以独立地加速，延时或者偏移。

 beginTime指定了动画开始之前的的延迟时间。这里的延迟从动画添加到可见图层的那一刻开始测量，默认是0（就是说动画会立刻执行）。

 speed是一个时间的倍数，默认1.0，减少它会减慢图层/动画的时间，增加它会加快速度。如果2.0的速度，那么对于一个duration为1的动画，实际上在0.5秒的时候就已经完成了。

 timeOffset和beginTime类似，但是和增加beginTime导致的延迟动画不同，增加timeOffset只是让动画快进到某一点，例如，对于一个持续1秒的动画来说，设置timeOffset为0.5意味着动画将从一半的地方开始。

 和beginTime不同的是，timeOffset并不受speed的影响。所以如果你把speed设为2.0，把timeOffset设置为0.5，那么你的动画将从动画最后结束的地方开始，因为1秒的动画实际上被缩短到了0.5秒。然而即使使用了timeOffset让动画从结束的地方开始，它仍然播放了一个完整的时长，这个动画仅仅是循环了一圈，然后从头开始播放。

 fillMode

 对于beginTime非0的一段动画来说，会出现一个当动画添加到图层上但什么也没发生的状态。类似的，removeOnCompletion被设置为NO的动画将会在动画结束的时候仍然保持之前的状态。这就产生了一个问题，当动画开始之前和动画结束之后，被设置动画的属性将会是什么值呢？

 一种可能是属性和动画没被添加之前保持一致，也就是在模型图层定义的值（见第七章“隐式动画”，模型图层和呈现图层的解释）。

 另一种可能是保持动画开始之前那一帧，或者动画结束之后的那一帧。这就是所谓的填充，因为动画开始和结束的值用来填充开始之前和结束之后的时间。

 这种行为就交给开发者了，它可以被CAMediaTiming的fillMode来控制。fillMode是一个NSString类型，可以接受如下四种常量：

 kCAFillModeForwards
 kCAFillModeBackwards
 kCAFillModeBoth
 kCAFillModeRemoved
 默认是kCAFillModeRemoved，当动画不再播放的时候就显示图层模型指定的值剩下的三种类型向前，向后或者即向前又向后去填充动画状态，使得动画在开始前或者结束后仍然保持开始和结束那一刻的值。

 这就对避免在动画结束的时候急速返回提供另一种方案（见第八章）。但是记住了，当用它来解决这个问题的时候，需要把removeOnCompletion设置为NO，另外需要给动画添加一个非空的键，于是可以在不需要动画的时候把它从图层上移除。
 */
class RelativeTimeViewController: BaseViewController {
    var groupAnimation = CAAnimationGroup()
    var shipLayerLayer = CALayer()

    @IBOutlet var timeOffsetSlider: UISlider!
    @IBOutlet var speedSlider: UISlider!
    @IBOutlet var timeOffsetLabel: UILabel!
    @IBOutlet var speedLabel: UILabel!
    @IBOutlet var containerView: UIView!
    var bezierPath = UIBezierPath()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "RelativeTimeViewController"

        bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 0, y: 150))
        bezierPath.addCurve(to: CGPoint(x: view.center.x, y: 150), controlPoint1: CGPoint(x: view.center.x / 2, y: 0), controlPoint2: CGPoint(x: 30, y: 300))

        bezierPath.move(to: CGPoint(x: view.center.x, y: 150))
        bezierPath.addCurve(to: CGPoint(x: view.frame.maxX - 50, y: 150), controlPoint1: CGPoint(x: view.center.x, y: 0), controlPoint2: CGPoint(x: view.frame.maxX - 50, y: 300))

        let pathLayer = CAShapeLayer()
        pathLayer.path = bezierPath.cgPath
        pathLayer.fillColor = UIColor.clear.cgColor
        pathLayer.strokeColor = UIColor.red.cgColor
        pathLayer.lineWidth = 3
        containerView.layer.addSublayer(pathLayer)

        shipLayerLayer.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        shipLayerLayer.position = CGPoint(x: 0, y: 150)
        shipLayerLayer.contents = UIImage(named: "ship")?.cgImage
        containerView.layer.addSublayer(shipLayerLayer)

        var transform = CATransform3DIdentity
        transform = CATransform3DRotate(transform, CGFloat(Double.pi / 2), 0, 0, 1)
        shipLayerLayer.transform = transform

        updateSliders()
    }

    func updateSliders() {
        let tiemOffset = timeOffsetSlider.value
        timeOffsetLabel.text = String(format: "%.02f", tiemOffset)
        let speed = speedSlider.value
        speedLabel.text = String(format: "%.02f", speed)
    }

    @IBAction func speedSliders(_ sender: Any) {
        let speed = speedSlider.value
        speedLabel.text = String(format: "%.02f", speed)
    }

    @IBAction func timeOffsetSliders(_ sender: Any) {
        let tiemOffset = timeOffsetSlider.value
        timeOffsetLabel.text = String(format: "%.02f", tiemOffset)
    }

    @IBAction func play(_ sender: Any) {
        let animation = CAKeyframeAnimation()
        animation.keyPath = "position"
        animation.timeOffset = CFTimeInterval(timeOffsetSlider.value)
        animation.speed = speedSlider.value
        animation.duration = 1
        animation.path = bezierPath.cgPath
        animation.rotationMode = .rotateAuto
        animation.isRemovedOnCompletion = false
        shipLayerLayer.add(animation, forKey: "slide")
    }
}
