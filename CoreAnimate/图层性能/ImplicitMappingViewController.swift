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
   */
class ImplicitMappingViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
