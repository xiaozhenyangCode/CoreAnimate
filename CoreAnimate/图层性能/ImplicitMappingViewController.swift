//
//  ImplicitMappingViewController.swift
//  CoreAnimate
//
//  Created by heiyanmini on 2020/10/12.
//  Copyright © 2020 heiyanmacmini. All rights reserved.
//

import UIKit
/**
  隐式绘制 Implicit mapping

  寄宿图可以通过Core Graphics直接绘制，也可以直接载入一个图片文件并赋值给contents属性，或事先绘制一个屏幕之外的CGContext上下文。在之前的两章中我们讨论了这些场景下的优化。但是除了常见的显式创建寄宿图，你也可以通过以下三种方式创建隐式的：1，使用特性的图层属性。2，特定的视图。3，特定的图层子类。
了解这个情况为什么发生何时发生是很重要的，它能够让你避免引入不必要的软件绘制行为。
 
 文本
 CATextLayer和UILabel都是直接将文本绘制在图层的寄宿图中。事实上这两种方式用了完全不同的渲染方式：在iOS 6及之前，UILabel用WebKit的HTML渲染引擎来绘制文本，而CATextLayer用的是Core Text.后者渲染更迅速，所以在所有需要绘制大量文本的情形下都优先使用它吧。但是这两种方法都用了软件的方式绘制，因此他们实际上要比硬件加速合成方式要慢。

 不论如何，尽可能地避免改变那些包含文本的视图的frame，因为这样做的话文本就需要重绘。例如，如果你想在图层的角落里显示一段静态的文本，但是这个图层经常改动，你就应该把文本放在一个子图层中。
 光栅化

 在第四章『视觉效果』中我们提到了CALayer的shouldRasterize属性，它可以解决重叠透明图层的混合失灵问题。同样在第12章『速度的曲调』中，它也是作为绘制复杂图层树结构的优化方法。

 启用shouldRasterize属性会将图层绘制到一个屏幕之外的图像。然后这个图像将会被缓存起来并绘制到实际图层的contents和子图层。如果有很多的子图层或者有复杂的效果应用，这样做就会比重绘所有事务的所有帧划得来得多。但是光栅化原始图像需要时间，而且还会消耗额外的内存。

 当我们使用得当时，光栅化可以提供很大的性能优势（如你在第12章所见），但是一定要避免作用在内容不断变动的图层上，否则它缓存方面的好处就会消失，而且会让性能变的更糟。

 为了检测你是否正确地使用了光栅化方式，用Instrument查看一下Color Hits Green和Misses Red项目，是否已光栅化图像被频繁地刷新（这样就说明图层并不是光栅化的好选择，或则你无意间触发了不必要的改变导致了重绘行为）。
   */
class ImplicitMappingViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
