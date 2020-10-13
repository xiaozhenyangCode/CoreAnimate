//
//  MixAndOverdrawViewController.swift
//  CoreAnimate
//
//  Created by heiyanmini on 2020/10/13.
//  Copyright © 2020 heiyanmacmini. All rights reserved.
//

import UIKit
/**
  混合和过度绘制  Mix and overdraw
  在第12章有提到，GPU每一帧可以绘制的像素有一个最大限制（就是所谓的fill rate），这个情况下可以轻易地绘制整个屏幕的所有像素。但是如果由于重叠图层的关系需要不停地重绘同一区域的话，掉帧就可能发生了。

    GPU会放弃绘制那些完全被其他图层遮挡的像素，但是要计算出一个图层是否被遮挡也是相当复杂并且会消耗处理器资源。同样，合并不同图层的透明重叠像素（即混合）消耗的资源也是相当客观的。所以为了加速处理进程，不到必须时刻不要使用透明图层。任何情况下，你应该这样做：

 给视图的backgroundColor属性设置一个固定的，不透明的颜色
 设置opaque属性为YES
    这样做减少了混合行为（因为编译器知道在图层之后的东西都不会对最终的像素颜色产生影响）并且计算得到了加速，避免了过度绘制行为因为Core Animation可以舍弃所有被完全遮盖住的图层，而不用每个像素都去计算一遍。

    如果用到了图像，尽量避免透明除非非常必要。如果图像要显示在一个固定的背景颜色或是固定的背景图之前，你没必要相对前景移动，你只需要预填充背景图片就可以避免运行时混色了。

    如果是文本的话，一个白色背景的UILabel（或者其他颜色）会比透明背景要更高效。

    最后，明智地使用shouldRasterize属性，可以将一个固定的图层体系折叠成单张图片，这样就不需要每一帧重新合成了，也就不会有因为子图层之间的混合和过度绘制的性能问题了。
   */
class MixAndOverdrawViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
