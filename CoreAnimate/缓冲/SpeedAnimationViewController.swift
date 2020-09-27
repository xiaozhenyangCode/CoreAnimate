//
//  SpeedAnimationViewController.swift
//  CoreAnimate
//
//  Created by heiyanmini on 2020/9/27.
//  Copyright © 2020 heiyanmacmini. All rights reserved.
//

import UIKit
/**
 动画速度
 动画实际上就是一段时间内的变化，这就暗示了变化一定是随着某个特定的速率进行。速率由以下公式计算而来：
 velocity = change / time

 这里的变化可以指的是一个物体移动的距离，时间指动画持续的时长，用这样的一个移动可以更加形象的描述（比如position和bounds属性的动画），但实际上它应用于任意可以做动画的属性（比如color和opacity）。

 上面的等式假设了速度在整个动画过程中都是恒定不变的（就如同第八章“显式动画”的情况），对于这种恒定速度的动画我们称之为“线性步调”，而且从技术的角度而言这也是实现动画最简单的方式，但也是完全不真实的一种效果。
 考虑一个场景，一辆车行驶在一定距离内，它并不会一开始就以60mph的速度行驶，然后到达终点后突然变成0mph。一是因为需要无限大的加速度（即使是最好的车也不会在0秒内从0跑到60），另外不然的话会干死所有乘客。在现实中，它会慢慢地加速到全速，然后当它接近终点的时候，它会慢慢地减速，直到最后停下来。

 那么对于一个掉落到地上的物体又会怎样呢？它会首先停在空中，然后一直加速到落到地面，然后突然停止（然后由于积累的动能转换伴随着一声巨响，砰！）。

 现实生活中的任何一个物体都会在运动中加速或者减速。那么我们如何在动画中实现这种加速度呢？一种方法是使用物理引擎来对运动物体的摩擦和动量来建模，然而这会使得计算过于复杂。我们称这种类型的方程为缓冲函数，幸运的是，Core Animation内嵌了一系列标准函数提供给我们使用。

 CAMediaTimingFunction

 那么该如何使用缓冲方程式呢？首先需要设置CAAnimation的timingFunction属性，是CAMediaTimingFunction类的一个对象。如果想改变隐式动画的计时函数，同样也可以使用CATransaction的+setAnimationTimingFunction:方法。
 这里有一些方式来创建CAMediaTimingFunction，最简单的方式是调用+timingFunctionWithName:的构造方法。这里传入如下几个常量之一：

 kCAMediaTimingFunctionLinear
 kCAMediaTimingFunctionEaseIn
 kCAMediaTimingFunctionEaseOut
 kCAMediaTimingFunctionEaseInEaseOut
 kCAMediaTimingFunctionDefault

 kCAMediaTimingFunctionLinear选项创建了一个线性的计时函数，同样也是CAAnimation的timingFunction属性为空时候的默认函数。线性步调对于那些立即加速并且保持匀速到达终点的场景会有意义（例如射出枪膛的子弹），但是默认来说它看起来很奇怪，因为对大多数的动画来说确实很少用到。

 kCAMediaTimingFunctionEaseIn常量创建了一个慢慢加速然后突然停止的方法。对于之前提到的自由落体的例子来说很适合，或者比如对准一个目标的导弹的发射。

 kCAMediaTimingFunctionEaseOut则恰恰相反，它以一个全速开始，然后慢慢减速停止。它有一个削弱的效果，应用的场景比如一扇门慢慢地关上，而不是砰地一声。

 kCAMediaTimingFunctionEaseInEaseOut创建了一个慢慢加速然后再慢慢减速的过程。这是现实世界大多数物体移动的方式，也是大多数动画来说最好的选择。如果只可以用一种缓冲函数的话，那就必须是它了。那么你会疑惑为什么这不是默认的选择，实际上当使用UIView的动画方法时，他的确是默认的，但当创建CAAnimation的时候，就需要手动设置它了。

 最后还有一个kCAMediaTimingFunctionDefault，它和kCAMediaTimingFunctionEaseInEaseOut很类似，但是加速和减速的过程都稍微有些慢。它和kCAMediaTimingFunctionEaseInEaseOut的区别很难察觉，可能是苹果觉得它对于隐式动画来说更适合（然后对UIKit就改变了想法，而是使用kCAMediaTimingFunctionEaseInEaseOut作为默认效果），虽然它的名字说是默认的，但还是要记住当创建显式的CAAnimation它并不是默认选项（换句话说，默认的图层行为动画用kCAMediaTimingFunctionDefault作为它们的计时方法）。

 UIView的动画缓冲

 UIKit的动画也同样支持这些缓冲方法的使用，尽管语法和常量有些不同，为了改变UIView动画的缓冲选项，给options参数添加如下常量之一：

 UIViewAnimationOptionCurveEaseInOut
 UIViewAnimationOptionCurveEaseIn
 UIViewAnimationOptionCurveEaseOut
 UIViewAnimationOptionCurveLinear
 它们和CAMediaTimingFunction紧密关联，UIViewAnimationOptionCurveEaseInOut是默认值（这里没有kCAMediaTimingFunctionDefault相对应的值了）。

 缓冲和关键帧动画

 或许你会回想起第八章里面颜色切换的关键帧动画由于线性变换的原因（见清单8.5）看起来有些奇怪，使得颜色变换非常不自然。为了纠正这点，我们来用更加合适的缓冲方法，例如kCAMediaTimingFunctionEaseIn，给图层的颜色变化添加一点脉冲效果，让它更像现实中的一个彩色灯泡。

 我们不想给整个动画过程应用这个效果，我们希望对每个动画的过程重复这样的缓冲，于是每次颜色的变换都会有脉冲效果。

 CAKeyframeAnimation有一个NSArray类型的timingFunctions属性，我们可以用它来对每次动画的步骤指定不同的计时函数。但是指定函数的个数一定要等于keyframes数组的元素个数减一，因为它是描述每一帧之间动画速度的函数。

 在这个例子中，我们自始至终想使用同一个缓冲函数，但我们同样需要一个函数的数组来告诉动画不停地重复每个步骤，而不是在整个动画序列只做一次缓冲，我们简单地使用包含多个相同函数拷贝的数组就可以了
 */
class SpeedAnimationViewController: BaseViewController {
    var colorLayer = CALayer()
    var colorView = UIView()

    var layerView: UIView!
    var changeColorLayer: CALayer!

    override func viewDidLoad() {
        super.viewDidLoad()
        colorLayer.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        colorLayer.position = CGPoint(x: view.frame.width / 2, y: view.frame.height / 2)
        colorLayer.backgroundColor = UIColor.red.cgColor
        view.layer.addSublayer(colorLayer)

        colorView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        colorView.center = view.center
        colorView.backgroundColor = .blue
        view.addSubview(colorView)

        view.backgroundColor = UIColor(red: 191 / 256, green: 191 / 256, blue: 191 / 256, alpha: 1.0)

        layerView = UIView(frame: CGRect(x: 100, y: 100, width: 200, height: 200))
        layerView.backgroundColor = .white
        view.addSubview(layerView)

        changeColorLayer = CALayer()
        changeColorLayer.frame = CGRect(x: 50, y: 50, width: 100, height: 100)
        changeColorLayer.backgroundColor = UIColor.blue.cgColor
        layerView.layer.addSublayer(changeColorLayer)

        let changeBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 110, height: 30))
        changeBtn.center = CGPoint(x: view.center.x - 85, y: changeColorLayer.frame.maxY + 30)
        changeBtn.setTitle("Change Color", for: .normal)
        changeBtn.setTitleColor(.blue, for: .normal)
        changeBtn.titleLabel?.font = .boldSystemFont(ofSize: 15)
        changeBtn.layer.cornerRadius = 10
        changeBtn.layer.borderWidth = 1
        changeBtn.addTarget(self, action: #selector(changeBtnClick), for: .touchUpInside)
        changeBtn.layer.borderColor = UIColor.gray.cgColor
        layerView.addSubview(changeBtn)
    }

    @objc func changeBtnClick() {
        let animation = CAKeyframeAnimation()
        animation.values = [arcrandomColor().cgColor, arcrandomColor().cgColor, arcrandomColor().cgColor]
        animation.keyPath = "backgroundColor"
        animation.duration = 2
        let fn = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.timingFunctions = [fn, fn, fn]
        changeColorLayer.add(animation, forKey: nil)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        CATransaction.begin()
        CATransaction.setAnimationDuration(1)
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: .easeInEaseOut))
        for touch: AnyObject in touches {
            let t: UITouch = touch as! UITouch
            let point = t.location(in: view)
            colorLayer.position = point
        }
        CATransaction.commit()

        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseInOut) {
            for touch: AnyObject in touches {
                let t: UITouch = touch as! UITouch
                let point = t.location(in: self.view)
                self.colorView.center = point
            }
        } completion: { _ in
        }
    }
}
