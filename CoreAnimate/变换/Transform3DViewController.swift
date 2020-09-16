//
//  Transform3DViewController.swift
//  CoreAnimate
//
//  Created by heiyanmacmini on 2020/9/16.
//  Copyright © 2020 heiyanmacmini. All rights reserved.
//

import UIKit
/**
   3D变换

   CG的前缀告诉我们，CGAffineTransform类型属于Core Graphics框架，Core Graphics实际上是一个严格意义上的2D绘图API，并且CGAffineTransform仅仅对2D变换有效。

  zPosition属性，可以用来让图层靠近或者远离相机（用户视角），transform属性（CATransform3D类型）可以真正做到这点，即让图层在3D空间内移动或者旋转。

   和CGAffineTransform类似，CATransform3D也是一个矩阵，但是和2x3的矩阵不同，CATransform3D是一个可以在3维空间内做变换的4x4的矩阵

  和CGAffineTransform矩阵类似，Core Animation提供了一系列的方法用来创建和组合CATransform3D类型的矩阵，和Core Graphics的函数类似，但是3D的平移和旋转多处了一个z参数，并且旋转函数除了angle之外多出了x,y,z三个参数，分别决定了每个坐标轴方向上的旋转：

  CATransform3DMakeRotation(CGFloat angle, CGFloat x, CGFloat y, CGFloat z)
  CATransform3DMakeScale(CGFloat sx, CGFloat sy, CGFloat sz)
  CATransform3DMakeTranslation(Gloat tx, CGFloat ty, CGFloat tz)

  透视投影

  在真实世界中，当物体远离我们的时候，由于视角的原因看起来会变小，理论上说远离我们的视图的边要比靠近视角的边跟短，但实际上并没有发生，而我们当前的视角是等距离的，也就是在3D变换中任然保持平行，和之前提到的仿射变换类似。

  在等距投影中，远处的物体和近处的物体保持同样的缩放比例，这种投影也有它自己的用处（例如建筑绘图，颠倒，和伪3D视频），但当前我们并不需要。

  为了做一些修正，我们需要引入投影变换（又称作z变换）来对除了旋转之外的变换矩阵做一些修改，Core Animation并没有给我们提供设置透视变换的函数，因此我们需要手动修改矩阵值，幸运的是，很简单：

  CATransform3D的透视效果通过一个矩阵中一个很简单的元素来控制：m34。m34用于按比例缩放X和Y的值来计算到底要离视角多远。
  m34的默认值是0，我们可以通过设置m34为-1.0 / d来应用透视效果，d代表了想象中视角相机和屏幕之间的距离，以像素为单位，那应该如何计算这个距离呢？实际上并不需要，大概估算一个就好了。

  因为视角相机实际上并不存在，所以可以根据屏幕上的显示效果自由决定它的防止的位置。通常500-1000就已经很好了，但对于特定的图层有时候更小后者更大的值会看起来更舒服，减少距离的值会增强透视效果，所以一个非常微小的值会让它看起来更加失真，然而一个非常大的值会让它基本失去透视效果，

  灭点
  当在透视角度绘图的时候，远离相机视角的物体将会变小变远，当远离到一个极限距离，它们可能就缩成了一个点，于是所有的物体最后都汇聚消失在同一个点。
 在现实中，这个点通常是视图的中心，于是为了在应用中创建拟真效果的透视，这个点应该聚在屏幕中点，或者至少是包含所有3D对象的视图中点。

 Core Animation定义了这个点位于变换图层的anchorPoint（通常位于图层中心，但也有例外）。这就是说，当图层发生变换时，这个点永远位于图层变换之前anchorPoint的位置。

 当改变一个图层的position，你也改变了它的灭点，做3D变换的时候要时刻记住这一点，当你视图通过调整m34来让它更加有3D效果，应该首先把它放置于屏幕中央，然后通过平移来把它移动到指定位置（而不是直接改变它的position），这样所有的3D图层都共享一个灭点。

 sublayerTransform属性

 如果有多个视图或者图层，每个都做3D变换，那就需要分别设置相同的m34值，并且确保在变换之前都在屏幕中央共享同一个position，如果用一个函数封装这些操作的确会更加方便，但仍然有限制（例如，你不能在Interface Builder中摆放视图），这里有一个更好的方法。

 CALayer有一个属性叫做sublayerTransform。它也是CATransform3D类型，但和对一个图层的变换不同，它影响到所有的子图层。这意味着你可以一次性对包含这些图层的容器做变换，于是所有的子图层都自动继承了这个变换方法。

 相较而言，通过在一个地方设置透视变换会很方便，同时它会带来另一个显著的优势：灭点被设置在容器图层的中点，从而不需要再对子图层分别设置了。这意味着你可以随意使用position和frame来放置子图层，而不需要把它们放置在屏幕中点，然后为了保证统一的灭点用变换来做平移。

 背面

 我们既然可以在3D场景下旋转图层，那么也可以从背面去观察它。如果我们在代码中把角度修改为M_PI（180度）而不是当前的M_PI_4（45度），那么将会把图层完全旋转一个半圈，于是完全背对了相机视角。

 如你所见，图层是双面绘制的，反面显示的是正面的一个镜像图片。

 但这并不是一个很好的特性，因为如果图层包含文本或者其他控件，那用户看到这些内容的镜像图片当然会感到困惑。另外也有可能造成资源的浪费：想象用这些图层形成一个不透明的固态立方体，既然永远都看不见这些图层的背面，那为什么浪费GPU来绘制它们呢？

 CALayer有一个叫做doubleSided的属性来控制图层的背面是否要被绘制。这是一个BOOL类型，默认为YES，如果设置为NO，那么当图层正面从相机视角消失的时候，它将不会被绘制。
 扁平化图层

 如果对包含已经做过变换的图层的图层做反方向的变换将会发什么什么呢？是不是有点困惑

 注意做了-45度旋转的内部图层是怎样抵消旋转45度的图层，从而恢复正常状态的。

 如果内部图层相对外部图层做了相反的变换（这里是绕Z轴的旋转），那么按照逻辑这两个变换将被相互抵消。

 但其实这并不是我们所看到的，相反，我们看到的结果如图5.18所示。发什么了什么呢？内部的图层仍然向左侧旋转，并且发生了扭曲，但按道理说它应该保持正面朝上，并且显示正常的方块。

 这是由于尽管Core Animation图层存在于3D空间之内，但它们并不都存在同一个3D空间。每个图层的3D场景其实是扁平化的，当你从正面观察一个图层，看到的实际上由子图层创建的想象出来的3D场景，但当你倾斜这个图层，你会发现实际上这个3D场景仅仅是被绘制在图层的表面。
 类似的，当你在玩一个3D游戏，实际上仅仅是把屏幕做了一次倾斜，或许在游戏中可以看见有一面墙在你面前，但是倾斜屏幕并不能够看见墙里面的东西。所有场景里面绘制的东西并不会随着你观察它的角度改变而发生变化；图层也是同样的道理。

 这使得用Core Animation创建非常复杂的3D场景变得十分困难。你不能够使用图层树去创建一个3D结构的层级关系—在相同场景下的任何3D表面必须和同样的图层保持一致，这是因为每个的父视图都把它的子视图扁平化了。

 至少当你用正常的CALayer的时候是这样，CALayer有一个叫做CATransformLayer的子类来解决这个问题。
                                        */
class Transform3DViewController: BaseViewController {
    var cat: UIImageView!
    var cat1: UIImageView!
    var cat2: UIImageView!
    var containerView: UIView!
    var outerView: UIView!
    var innerView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        cat = UIImageView(image: UIImage(named: "cat"))
        view.addSubview(cat)
        cat.frame = CGRect(x: 0, y: 0, width: cat.image!.size.width / 2, height: cat.image!.size.height / 2)
        cat.center = CGPoint(x: view.center.x, y: 200)

        containerView = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 200))
        containerView.backgroundColor = .brown
        view.addSubview(containerView)
        containerView.center = CGPoint(x: view.center.x, y: 450)

        cat1 = UIImageView(image: UIImage(named: "cat"))
        containerView.addSubview(cat1)
        cat1.frame = CGRect(x: 10, y: 10, width: 100, height: 180)

        cat2 = UIImageView(image: UIImage(named: "cat"))
        containerView.addSubview(cat2)
        cat2.frame = CGRect(x: 190, y: 10, width: 100, height: 180)

        outerView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        outerView.layer.shadowRadius = 20
        outerView.layer.shadowOpacity = 1
        outerView.backgroundColor = .red
        view.addSubview(outerView)
        outerView.center = CGPoint(x: view.center.x, y: 680)

        innerView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        innerView.backgroundColor = .blue
        view.addSubview(innerView)
        innerView.center = outerView.center
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /**
         // 绕y轴旋转45度的视图
         let transform = CATransform3DMakeRotation(CGFloat(Double.pi) / 4, 0, 1, 0)
               UIView.animate(withDuration: 0.25) {
                   self.cat.layer.transform = transform
               }
         */
        /// 对变换应用透视效果
        // create a new transform
        var transform = CATransform3DIdentity
        // apply perspective
        transform.m34 = -1.0 / 500.0
        // rotate by 45 degrees along the Y axis
        transform = CATransform3DRotate(transform, CGFloat(Double.pi / 4), 0, 1, 0)
        // apply to layer

        UIView.animate(withDuration: 0.25) {
            self.cat.layer.transform = transform
            // apply perspective transform to container
            var perspective = CATransform3DIdentity
            perspective.m34 = -1.0 / 500.0
            self.containerView.layer.sublayerTransform = perspective
            // rotate layerView1 by 45 degrees along the Y axis
            let transform1 = CATransform3DMakeRotation(CGFloat(Double.pi), 0, 1, 0)
            self.cat1.layer.transform = transform1
            // rotate layerView2 by 45 degrees along the Y axis
            let transform2 = CATransform3DMakeRotation(CGFloat(-Double.pi / 4), 0, 1, 0)
            self.cat2.layer.transform = transform2
//            //  // rotate the outer layer 45 degrees
//            let outer = CATransform3DMakeRotation(CGFloat(Double.pi / 4), 0, 0, 1)
//            // rotate the inner layer -45 degrees
//            let inner = CATransform3DMakeRotation(CGFloat(-Double.pi / 2), 0, 0, 1)

//            self.outerView.layer.transform = outer
//
//            self.innerView.layer.transform = inner

            // rotate the outer layer 45 degrees
            var outer = CATransform3DIdentity
            outer.m34 = -1.0 / 500.0
            outer = CATransform3DMakeRotation(CGFloat(Double.pi / 4), 0, 1, 0)
            self.outerView.layer.transform = outer
            // rotate the inner layer -45 degrees
            var inner = CATransform3DIdentity
            inner.m34 = -1.0 / 500.0
            inner = CATransform3DMakeRotation(CGFloat(-Double.pi / 4), 0, 1, 0)
            self.innerView.layer.transform = inner
        }
    }
}
