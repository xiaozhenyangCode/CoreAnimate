//
//  TensilefilterViewController.swift
//  CoreAnimate
//
//  Created by heiyanmacmini on 2020/9/15.
//  Copyright © 2020 heiyanmacmini. All rights reserved.
//

import UIKit
/**
 minificationFilter和magnificationFilter属性。总得来讲，当我们视图显示一个图片的时候，都应该正确地显示这个图片（意即：以正确的比例和正确的1：1像素显示在屏幕上）。原因如下：

 能够显示最好的画质，像素既没有被压缩也没有被拉伸。
 能更好的使用内存，因为这就是所有你要存储的东西。
 最好的性能表现，CPU不需要为此额外的计算。

 不过有时候，显示一个非真实大小的图片确实是我们需要的效果。比如说一个头像或是图片的缩略图，再比如说一个可以被拖拽和伸缩的大图。这些情况下，为同一图片的不同大小存储不同的图片显得又不切实际。

  当图片需要显示不同的大小的时候，有一种叫做拉伸过滤的算法就起到作用了。它作用于原图的像素上并根据需要生成新的像素显示在屏幕上。

 事实上，重绘图片大小也没有一个统一的通用算法。这取决于需要拉伸的内容，放大或是缩小的需求等这些因素。CALayer为此提供了三种拉伸过滤方法，他们是：

 kCAFilterLinear
 kCAFilterNearest
 kCAFilterTrilinear
     minification（缩小图片）和magnification（放大图片）默认的过滤器都是kCAFilterLinear，这个过滤器采用双线性滤波算法，它在大多数情况下都表现良好。双线性滤波算法通过对多个像素取样最终生成新的值，得到一个平滑的表现不错的拉伸。但是当放大倍数比较大的时候图片就模糊不清了。

     kCAFilterTrilinear和kCAFilterLinear非常相似，大部分情况下二者都看不出来有什么差别。但是，较双线性滤波算法而言，三线性滤波算法存储了多个大小情况下的图片（也叫多重贴图），并三维取样，同时结合大图和小图的存储进而得到最后的结果。

     这个方法的好处在于算法能够从一系列已经接近于最终大小的图片中得到想要的结果，也就是说不要对很多像素同步取样。这不仅提高了性能，也避免了小概率因舍入错误引起的取样失灵的问题

 kCAFilterNearest是一种比较武断的方法。从名字不难看出，这个算法（也叫最近过滤）就是取样最近的单像素点而不管其他的颜色。这样做非常快，也不会使图片模糊。但是，最明显的效果就是，会使得压缩图片更糟，图片放大之后也显得块状或是马赛克严重

 对于没有斜线的小图来说，最近过滤算法要好很多

 总的来说，对于比较小的图或者是差异特别明显，极少斜线的大图，最近过滤算法会保留这种差异明显的特质以呈现更好的结果。但是对于大多数的图尤其是有很多斜线或是曲线轮廓的图片来说，最近过滤算法会导致更差的结果。换句话说，线性过滤保留了形状，最近过滤则保留了像素的差异。
 */
class TensilefilterViewController: BaseViewController {
    var timer: Timer?
    var digitViews = [UIView]()

    override func viewDidLoad() {
        super.viewDidLoad()

        for index in 0 ... 5 {
            let childView = UIView()
            childView.tag = index
            childView.frame = CGRect(x: (index * 50) + 50, y: 300, width: 40, height: 50)
            digitViews.append(childView)
            view.addSubview(childView)
        }

        let digits = UIImage(named: "digits")
        for item in digitViews {
            item.layer.contents = digits?.cgImage
            item.layer.contentsRect = CGRect(x: 0, y: 0, width: 0.1, height: 1)
            item.layer.contentsGravity = .resizeAspect
        }
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: Proxy(self), selector: #selector(tick), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: .common)
        tick()
    }

    @objc func tick() {
        let calender = Calendar(identifier: .gregorian)
        let components = calender.dateComponents([.hour, .minute, .second], from: Date())

        setDigit(components.hour ?? 0 / 10, digitViews[0])
        setDigit(components.hour ?? 0 % 10, digitViews[1])
        setDigit(components.minute ?? 0 / 10, digitViews[2])
        setDigit(components.minute ?? 0 % 10, digitViews[3])
        setDigit(components.second ?? 0 / 10, digitViews[4])
        setDigit(components.second ?? 0 % 10, digitViews[5])
    }

    func setDigit(_ digit: Int, _ view: UIView) {
        view.layer.contentsRect = CGRect(x: Double(digit) * 0.1, y: 0, width: 0.1, height: 1.0)
    }

    deinit {
        timer?.fireDate = Date.distantFuture
        timer?.invalidate()
        timer = nil
    }
}
