//
//  TiledLayerViewController.swift
//  CoreAnimate
//
//  Created by heiyanmini on 2020/9/21.
//  Copyright © 2020 heiyanmacmini. All rights reserved.
//

import UIKit
/**
 CATiledLayer

 有些时候你可能需要绘制一个很大的图片，常见的例子就是一个高像素的照片或者是地球表面的详细地图。iOS应用通畅运行在内存受限的设备上，所以读取整个图片到内存中是不明智的。载入大图可能会相当地慢，那些对你看上去比较方便的做法（在主线程调用UIImage的-imageNamed:方法或者-imageWithContentsOfFile:方法）将会阻塞你的用户界面，至少会引起动画卡顿现象。

 能高效绘制在iOS上的图片也有一个大小限制。所有显示在屏幕上的图片最终都会被转化为OpenGL纹理，同时OpenGL有一个最大的纹理尺寸（通常是2048*2048，或4096*4096，这个取决于设备型号）。如果你想在单个纹理中显示一个比这大的图，即便图片已经存在于内存中了，你仍然会遇到很大的性能问题，因为Core Animation强制用CPU处理图片而不是更快的GPU。

 CATiledLayer为载入大图造成的性能问题提供了一个解决方案：将大图分解成小片然后将他们单独按需载入。让我们用实验来证明一下。

 小片裁剪

 这个示例中，我们将会从一个2048*2048分辨率的雪人图片入手。为了能够从CATiledLayer中获益，我们需要把这个图片裁切成许多小一些的图片。你可以通过代码来完成这件事情，但是如果你在运行时读入整个图片并裁切，那CATiledLayer这些所有的性能优点就损失殆尽了。理想情况下来说，最好能够逐个步骤来实现。

 当你滑动这个图片，你会发现当CATiledLayer载入小图的时候，他们会淡入到界面中。这是CATiledLayer的默认行为。（你可能已经在iOS 6之前的苹果地图程序中见过这个效果）你可以用fadeDuration属性改变淡入时长或直接禁用掉。CATiledLayer（不同于大部分的UIKit和Core Animation方法）支持多线程绘制，-drawLayer:inContext:方法可以在多个线程中同时地并发调用，所以请小心谨慎地确保你在这个方法中实现的绘制代码是线程安全的。
 Retina小图

 你也许已经注意到了这些小图并不是以Retina的分辨率显示的。为了以屏幕的原生分辨率来渲染CATiledLayer，我们需要设置图层的contentsScale来匹配UIScreen的scale属性：

 tileLayer.contentsScale = [UIScreen mainScreen].scale;

 有趣的是，tileSize是以像素为单位，而不是点，所以增大了contentsScale就自动有了默认的小图尺寸（现在它是128*128的点而不是256*256）.所以，我们不需要手工更新小图的尺寸或是在Retina分辨率下指定一个不同的小图。我们需要做的是适应小图渲染代码以对应安排scale的变化，然而：
 //determine tile coordinate
 CGRect bounds = CGContextGetClipBoundingBox(ctx);
 CGFloat scale = [UIScreen mainScreen].scale;
 NSInteger x = floor(bounds.origin.x / layer.tileSize.width * scale);
 NSInteger y = floor(bounds.origin.y / layer.tileSize.height * scale);

 通过这个方法纠正scale也意味着我们的雪人图将以一半的大小渲染在Retina设备上（总尺寸是1024*1024，而不是2048*2048）。这个通常都不会影响到用CATiledLayer正常显示的图片类型（比如照片和地图，他们在设计上就是要支持放大缩小，能够在不同的缩放条件下显示），但是也需要在心里明白。
 */
class TiledLayerViewController: BaseViewController, CALayerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()

        let scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.width))
        scrollView.center = view.center
        view.addSubview(scrollView)

        let tileLayer = CATiledLayer()
        tileLayer.frame = CGRect(x: 0, y: 0, width: 2048, height: 2048)
        tileLayer.delegate = self
        tileLayer.contentsScale = UIScreen.main.scale
        scrollView.layer.addSublayer(tileLayer)

        scrollView.contentSize = tileLayer.frame.size

        tileLayer.setNeedsDisplay()
    }

    func draw(_ layer: CALayer, in ctx: CGContext) {
        let bounds = ctx.boundingBoxOfClipPath
        let x = floor(bounds.origin.x / (layer as! CATiledLayer).tileSize.width)
        let y = floor(bounds.origin.y / (layer as! CATiledLayer).tileSize.height)

//        let imageName = String(format: "伽罗-_%.02i太华_%.02i", x, y)

        let tileImage = UIImage(named: "伽罗-太华")

        UIGraphicsPushContext(ctx)
        tileImage?.draw(in: bounds)
        UIGraphicsPopContext()
    }
}
