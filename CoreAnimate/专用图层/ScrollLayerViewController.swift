//
//  ScrollLayerViewController.swift
//  CoreAnimate
//
//  Created by heiyanmini on 2020/9/21.
//  Copyright © 2020 heiyanmacmini. All rights reserved.
//

import UIKit
/**
 CAScrollLayer

 对于一个未转换的图层，它的bounds和它的frame是一样的，frame属性是由bounds属性自动计算而出的，所以更改任意一个值都会更新其他值。

 但是如果你只想显示一个大图层里面的一小部分呢。比如说，你可能有一个很大的图片，你希望用户能够随意滑动，或者是一个数据或文本的长列表。在一个典型的iOS应用中，你可能会用到UITableView或是UIScrollView，但是对于独立的图层来说，什么会等价于刚刚提到的UITableView和UIScrollView呢？

 在第二章中，我们探索了图层的contentsRect属性的用法，它的确是能够解决在图层中小地方显示大图片的解决方法。但是如果你的图层包含子图层那它就不是一个非常好的解决方案，因为，这样做的话每次你想『滑动』可视区域的时候，你就需要手工重新计算并更新所有的子图层位置。

 这个时候就需要CAScrollLayer了。CAScrollLayer有一个-scrollToPoint:方法，它自动适应bounds的原点以便图层内容出现在滑动的地方。注意，这就是它做的所有事情。前面提到过，Core Animation并不处理用户输入，所以CAScrollLayer并不负责将触摸事件转换为滑动事件，既不渲染滚动条，也不实现任何iOS指定行为例如滑动反弹（当视图滑动超多了它的边界的将会反弹回正确的地方）。

 让我们来用CAScrollLayer来常见一个基本的UIScrollView替代品。我们将会用CAScrollLayer作为视图的宿主图层，并创建一个自定义的UIView，然后用UIPanGestureRecognizer实现触摸事件响应。ScrollView显示了一个大于它的frame的UIImageView。

 不同于UIScrollView，我们定制的滑动视图类并没有实现任何形式的边界检查（bounds checking）。图层内容极有可能滑出视图的边界并无限滑下去。CAScrollLayer并没有等同于UIScrollView中contentSize的属性，所以当CAScrollLayer滑动的时候完全没有一个全局的可滑动区域的概念，也无法自适应它的边界原点至你指定的值。它之所以不能自适应边界大小是因为它不需要，内容完全可以超过边界。

 那你一定会奇怪用CAScrollLayer的意义到底何在，因为你可以简单地用一个普通的CALayer然后手动适应边界原点啊。真相其实并不复杂，UIScrollView并没有用CAScrollLayer，事实上，就是简单的通过直接操作图层边界来实现滑动。

 CAScrollLayer有一个潜在的有用特性。如果你查看CAScrollLayer的头文件，你就会注意到有一个扩展分类实现了一些方法和属性：

 - (void)scrollPoint:(CGPoint)p;
 - (void)scrollRectToVisible:(CGRect)r;
 @property(readonly) CGRect visibleRect;
 看到这些方法和属性名，你也许会以为这些方法给每个CALayer实例增加了滑动功能。但是事实上他们只是放置在CAScrollLayer中的图层的实用方法。scrollPoint:方法从图层树中查找并找到第一个可用的CAScrollLayer，然后滑动它使得指定点成为可视的。scrollRectToVisible:方法实现了同样的事情只不过是作用在一个矩形上的。visibleRect属性决定图层（如果存在的话）的哪部分是当前的可视区域。如果你自己实现这些方法就会相对容易明白一点，但是CAScrollLayer帮你省了这些麻烦，所以当涉及到实现图层滑动的时候就可以用上了。
 */
class ScrollLayerViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 191 / 256, green: 191 / 256, blue: 191 / 256, alpha: 1.0)

        let scrollView = ScrollView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        scrollView.backgroundColor = arcrandomColor()
        view.addSubview(scrollView)
        scrollView.center = view.center

        let imageView = UIImageView(frame: scrollView.bounds)
        imageView.image = UIImage(named: "github")
        scrollView.addSubview(imageView)
    }
}

class ScrollView: UIView {
    override class var layerClass: AnyClass {
        return CAScrollLayer.self
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
        layer.masksToBounds = true

        let recognizer = UIPanGestureRecognizer(target: self, action: #selector(pan))
        addGestureRecognizer(recognizer)
    }

    @objc func pan(_ pan: UIPanGestureRecognizer) {
        var offset = bounds.origin
        offset.x -= pan.translation(in: self).x
        offset.y -= pan.translation(in: self).y

        (layer as! CAScrollLayer).scroll(to: offset)

        pan.setTranslation(.zero, in: self)
    }
}
