//
//  ReplicatorLayerViewController.swift
//  CoreAnimate
//
//  Created by 振阳的 Macbook Pro on 2020/9/19.
//  Copyright © 2020 heiyanmacmini. All rights reserved.
//
// Replicator 复制因子
import UIKit
/**
  CAReplicatorLayer

  CAReplicatorLayer的目的是为了高效生成许多相似的图层。它会绘制一个或多个图层的子图层，并在每个复制体上应用不同的变换。

  重复图层（Repeating Layers）

 我们在屏幕的中间创建了一个小白色方块图层，然后用CAReplicatorLayer生成十个图层组成一个圆圈。instanceCount属性指定了图层需要重复多少次。instanceTransform指定了一个CATransform3D3D变换（这种情况下，下一图层的位移和旋转将会移动到圆圈的下一个点）。

  变换是逐步增加的，每个实例都是相对于前一实例布局。这就是为什么这些复制体最终不会出现在同意位置上

 注意到当图层在重复的时候，他们的颜色也在变化：这是用instanceBlueOffset和instanceGreenOffset属性实现的。通过逐步减少蓝色和绿色通道，我们逐渐将图层颜色转换成了红色。这个复制效果看起来很酷，但是CAReplicatorLayer真正应用到实际程序上的场景比如：一个游戏中导弹的轨迹云，或者粒子爆炸（尽管iOS 5已经引入了CAEmitterLayer，它更适合创建任意的粒子效果）

 反射

 使用CAReplicatorLayer并应用一个负比例变换于一个复制图层，你就可以创建指定视图（或整个视图层次）内容的镜像图片，这样就创建了一个实时的『反射』效果。让我们来尝试实现这个创意：指定一个继承于UIView的ReflectionView，它会自动产生内容的反射效果。实现这个效果的代码很简单，实际上用ReflectionView实现这个效果会更简单，它就会实时生成子视图的反射，而不需要别的代码。

 开源代码ReflectionView完成了一个自适应的渐变淡出效果（用CAGradientLayer和图层蒙板实现），代码见 https://github.com/nicklockwood/ReflectionView
                                         */
class ReplicatorLayerViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 191 / 256, green: 191 / 256, blue: 191 / 256, alpha: 1.0)

        let containerView = UIView(frame: CGRect(x: 100, y: 50, width: 200, height: 200))
        view.addSubview(containerView)

        let replicator = CAReplicatorLayer()
        replicator.frame = containerView.bounds
        containerView.layer.addSublayer(replicator)

        replicator.instanceCount = 10

        var transform = CATransform3DIdentity
        transform = CATransform3DTranslate(transform, 0, 200, 0)
        transform = CATransform3DRotate(transform, CGFloat(Double.pi / 5), 0, 0, 1)
        transform = CATransform3DTranslate(transform, 0, -200, 0)
        replicator.instanceTransform = transform

        replicator.instanceBlueOffset = -0.1
        replicator.instanceGreenOffset = -0.1

        let layer = CALayer()
        layer.frame = CGRect(x: 100, y: 100, width: 100, height: 100)
        layer.backgroundColor = UIColor.white.cgColor
        replicator.addSublayer(layer)

        let reflectionView = ReflectionView(frame: CGRect(x: 100, y: 550, width: 200, height: 200))
        view.addSubview(reflectionView)

        let imageView = UIImageView(frame: reflectionView.bounds)
        imageView.image = UIImage(named: "github")
        reflectionView.addSubview(imageView)
    }
}

class ReflectionView: UIView {
    override class var layerClass: AnyClass {
        return CAReplicatorLayer.self
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setUp()
    }

    func setUp() {
        let replicatorLayer = layer as! CAReplicatorLayer
        replicatorLayer.instanceCount = 2

        var transform = CATransform3DIdentity
        let verticalOffset = bounds.size.height + 2
        transform = CATransform3DTranslate(transform, 0, verticalOffset, 0)
        transform = CATransform3DScale(transform, 1, -1, 0)
        replicatorLayer.instanceTransform = transform

        replicatorLayer.instanceAlphaOffset = -0.6
    }
}
