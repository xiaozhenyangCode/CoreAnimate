//
//  SolidObjectViewController.swift
//  CoreAnimate
//
//  Created by heiyanmacmini on 2020/9/16.
//  Copyright © 2020 heiyanmacmini. All rights reserved.
//

import UIKit
/**
   固体对象

   现在你懂得了在3D空间的一些图层布局的基础，我们来试着创建一个固态的3D对象（实际上是一个技术上所谓的空洞对象，但它以固态呈现）。我们用六个独立的视图来构建一个立方体的各个面。
   从这个角度看立方体并不是很明显；看起来只是一个方块，为了更好地欣赏它，我们将更换一个不同的视角。

   旋转这个立方体将会显得很笨重，因为我们要单独对每个面做旋转。另一个简单的方案是通过调整容器视图的sublayerTransform去旋转照相机。

   添加如下几行去旋转containerView图层的perspective变换矩阵：
   perspective = CATransform3DRotate(perspective, CGFloat(-Double.pi / 4), 1, 0, 0)
   perspective = CATransform3DRotate(perspective, CGFloat(-Double.pi / 4), 0, 1, 0)
   这就对相机（或者相对相机的整个场景，你也可以这么认为）绕Y轴旋转45度，并且绕X轴旋转45度。现在从另一个角度去观察立方体，就能看出它的真实面貌

   光亮和阴影

   现在它看起来更像是一个立方体没错了，但是对每个面之间的连接还是很难分辨。Core Animation可以用3D显示图层，但是它对光线并没有概念。如果想让立方体看起来更加真实，需要自己做一个阴影效果。你可以通过改变每个面的背景颜色或者直接用带光亮效果的图片来调整。

   如果需要动态地创建光线效果，你可以根据每个视图的方向应用不同的alpha值做出半透明的阴影图层，但为了计算阴影图层的不透明度，你需要得到每个面的正太向量（垂直于表面的向量），然后根据一个想象的光源计算出两个向量叉乘结果。叉乘代表了光源和图层之间的角度，从而决定了它有多大程度上的光亮。

 .10实现了这样一个结果，我们用GLKit框架来做向量的计算（你需要引入GLKit库来运行代码），每个面的CATransform3D都被转换成GLKMatrix4，然后通过GLKMatrix4GetMatrix3函数得出一个3×3的旋转矩阵。这个旋转矩阵指定了图层的方向，然后可以用它来得到正太向量的值。

  ，试着调整LIGHT_DIRECTION和AMBIENT_LIGHT的值来切换光线效果
 点击事件

 你应该能注意到现在可以在第三个表面的顶部看见按钮了，点击它，什么都没发生，为什么呢？

 这并不是因为iOS在3D场景下正确地处理响应事件，实际上是可以做到的。问题在于视图顺序。在第三章中我们简要提到过，点击事件的处理由视图在父视图中的顺序决定的，并不是3D空间中的Z轴顺序。当给立方体添加视图的时候，我们实际上是按照一个顺序添加，所以按照视图/图层顺序来说，4，5，6在3的前面。

 即使我们看不见4，5，6的表面（因为被1，2，3遮住了），iOS在事件响应上仍然保持之前的顺序。当试图点击表面3上的按钮，表面4，5，6截断了点击事件（取决于点击的位置），这就和普通的2D布局在按钮上覆盖物体一样。

 你也许认为把doubleSided设置成NO可以解决这个问题，因为它不再渲染视图后面的内容，但实际上并不起作用。因为背对相机而隐藏的视图仍然会响应点击事件（这和通过设置hidden属性或者设置alpha为0而隐藏的视图不同，那两种方式将不会响应事件）。所以即使禁止了双面渲染仍然不能解决这个问题（虽然由于性能问题，还是需要把它设置成NO）。

 这里有几种正确的方案：把除了表面3的其他视图userInteractionEnabled属性都设置成NO来禁止事件传递。或者简单通过代码把视图3覆盖在视图6上。无论怎样都可以点击按钮了

                                */
class SolidObjectViewController: BaseViewController {
    var containerView: UIView!
    var faces = [UIView]()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 191 / 256, green: 191 / 256, blue: 191 / 256, alpha: 1.0)
        containerView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        containerView.center = view.center
        view.addSubview(containerView)
        for index in 0 ... 5 {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
            view.backgroundColor = .white
            view.tag = index
            let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
            btn.setTitle("\(index + 1)", for: .normal)
            btn.tag = index
            btn.setTitleColor(arcrandomColor(), for: .normal)
            btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 100)
            btn.addTarget(self, action: #selector(btnClick(_:)), for: .touchUpInside)
            btn.center = view.center
            btn.layer.cornerRadius = 20
            btn.layer.shadowOpacity = 0.3
            view.isUserInteractionEnabled = index <= 2
            view.addSubview(btn)
            faces.append(view)
        }
        // set up the container sublayer transform
        var perspective = CATransform3DIdentity
        perspective.m34 = -1 / 500
        perspective = CATransform3DRotate(perspective, CGFloat(-Double.pi / 4), 1, 0, 0)
        perspective = CATransform3DRotate(perspective, CGFloat(-Double.pi / 4), 0, 1, 0)
        containerView.layer.sublayerTransform = perspective
        // add cube face 1
        var transform = CATransform3DMakeTranslation(0, 0, 100)
        addFace(0, transform)
        // add cube face 2
        transform = CATransform3DMakeTranslation(100, 0, 0)
        transform = CATransform3DRotate(transform, CGFloat(Double.pi / 2), 0, 1, 0)
        addFace(1, transform)
        // add cube face 3
        transform = CATransform3DMakeTranslation(0, -100, 0)
        transform = CATransform3DRotate(transform, CGFloat(Double.pi / 2), 1, 0, 0)
        addFace(2, transform)
        // add cube face 4
        transform = CATransform3DMakeTranslation(0, 100, 0)
        transform = CATransform3DRotate(transform, -CGFloat(Double.pi / 2), 1, 0, 0)
        addFace(3, transform)
        // add cube face 5
        transform = CATransform3DMakeTranslation(-100, 0, 0)
        transform = CATransform3DRotate(transform, -CGFloat(Double.pi / 2), 0, 1, 0)
        addFace(4, transform)
        // add cube face 6
        transform = CATransform3DMakeTranslation(0, 0, -100)
        transform = CATransform3DRotate(transform, CGFloat(Double.pi), 0, 1, 0)
        addFace(5, transform)

//        timer = Timer.scheduledTimer(timeInterval: 0.1, target: Proxy(self), selector: #selector(tick), userInfo: nil, repeats: true)
//        RunLoop.main.add(timer!, forMode: .common)
    }

    func applyLightingToFace(_ face: CALayer) {
        let layer = CALayer()
        layer.frame = face.bounds
        face.addSublayer(layer)
        let transform = face.transform
        let matrix4 = GLKMatrix4(m: (Float(transform.m11), Float(transform.m12), Float(transform.m13), Float(transform.m14), Float(transform.m21), Float(transform.m22), Float(transform.m23), Float(transform.m24), Float(transform.m31), Float(transform.m32), Float(transform.m33), Float(transform.m34), Float(transform.m41), Float(transform.m42), Float(transform.m43), Float(transform.m44)))

        let matrix3 = GLKMatrix4GetMatrix3(matrix4)

        // get face normal
        var normal = GLKVector3Make(0, 0, 1)
        normal = GLKMatrix3MultiplyVector3(matrix3, normal)
        normal = GLKVector3Normalize(normal)
        // get dot product with light direction
        let light = GLKVector3Normalize(GLKVector3Make(0, 1, -0.5))
        let dotProduct = GLKVector3DotProduct(light, normal)
        // set lighting layer opacity
        let shadow = 1 + dotProduct - 0.5
        let color = UIColor(white: 0, alpha: CGFloat(shadow))
        layer.backgroundColor = color.cgColor
    }

    func addFace(_ index: Int, _ transform: CATransform3D) {
        let face = faces[index]
        containerView.addSubview(face)
        let containerSize = containerView.bounds.size
        face.center = CGPoint(x: containerSize.width / 2, y: containerSize.height / 2)
        face.layer.transform = transform
        applyLightingToFace(face.layer)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        timer?.fire()
//        tick()
    }

    @objc func tick() {
    }

    var timer: Timer?
    @objc func btnClick(_ sender: UIButton) {
        sender.backgroundColor = arcrandomColor()
        sender.setTitleColor(arcrandomColor(), for: .normal)
    }

    deinit {
        timer?.fireDate = Date.distantFuture
        timer?.invalidate()
        timer = nil
    }
}
