//
//  CompleteBlockViewController.swift
//  CoreAnimate
//
//  Created by heiyanmini on 2020/9/22.
//  Copyright © 2020 heiyanmacmini. All rights reserved.
//

import UIKit
/**
 完成块 Complete block
 基于UIView的block的动画允许你在动画结束的时候提供一个完成的动作。CATranscation接口提供的+setCompletionBlock:方法也有同样的功能。我们来调整上个例子，在颜色变化结束之后执行一些操作。我们来添加一个完成之后的block，用来在每次颜色变化结束之后切换到另一个旋转90的动画。
 注意旋转动画要比颜色渐变快得多，这是因为完成块是在颜色渐变的事务提交并出栈之后才被执行，于是，用默认的事务做变换，默认的时间也就变成了0.25秒
 */
class CompleteBlockViewController: BaseViewController {
    var layerView: UIView!
    var colorLayer: CALayer!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 191 / 256, green: 191 / 256, blue: 191 / 256, alpha: 1.0)

        layerView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        layerView.backgroundColor = .white
        view.addSubview(layerView)
        layerView.center = view.center

        colorLayer = CALayer()
        colorLayer.frame = CGRect(x: 50, y: 50, width: 100, height: 100)
        colorLayer.backgroundColor = UIColor.blue.cgColor
        layerView.layer.addSublayer(colorLayer)

        let changeBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 110, height: 30))
        changeBtn.center = CGPoint(x: view.center.x - 85, y: colorLayer.frame.maxY + 30)
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
        CATransaction.begin()
        CATransaction.setAnimationDuration(1)
        CATransaction.setCompletionBlock {
            var transform = self.colorLayer.affineTransform()
            transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 4))
            self.colorLayer.setAffineTransform(transform)
        }
        colorLayer.backgroundColor = arcrandomColor().cgColor
        CATransaction.commit()
    }
}
