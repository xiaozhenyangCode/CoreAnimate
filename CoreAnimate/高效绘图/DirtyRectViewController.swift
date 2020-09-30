//
//  DirtyRectViewController.swift
//  CoreAnimate
//
//  Created by heiyanmini on 2020/9/29.
//  Copyright © 2020 heiyanmacmini. All rights reserved.
//

import UIKit
/**
  脏矩形

  有时候用CAShapeLayer或者其他矢量图形图层替代Core Graphics并不是那么切实可行。比如我们的绘图应用：我们用线条完美地完成了矢量绘制。但是设想一下如果我们能进一步提高应用的性能，让它就像一个黑板一样工作，然后用『粉笔』来绘制线条。模拟粉笔最简单的方法就是用一个『线刷』图片然后将它粘贴到用户手指碰触的地方，但是这个方法用CAShapeLayer没办法实现。

  我们可以给每个『线刷』创建一个独立的图层，但是实现起来有很大的问题。屏幕上允许同时出现图层上线数量大约是几百，那样我们很快就会超出的。这种情况下我们没什么办法，就用Core Graphics吧（除非你想用OpenGL做一些更复杂的事情）。

  我们的『黑板』应用的最初实现见清单13.3，我们更改了之前版本的DrawingView，用一个画刷位置的数组代替UIBezierPath。

  这个实现在模拟器上表现还不错，但是在真实设备上就没那么好了。问题在于每次手指移动的时候我们就会重绘之前的线刷，即使场景的大部分并没有改变。我们绘制地越多，就会越慢。随着时间的增加每次重绘需要更多的时间，帧数也会下降（见图13.3），如何提高性能呢？

  为了减少不必要的绘制，MacOS和iOS设备将会把屏幕区分为需要重绘的区域和不需要重绘的区域。那些需要重绘的部分被称作『脏区域』。在实际应用中，鉴于非矩形区域边界裁剪和混合的复杂性，通常会区分出包含指定视图的矩形位置，而这个位置就是『脏矩形』。

  当一个视图被改动过了，TA可能需要重绘。但是很多情况下，只是这个视图的一部分被改变了，所以重绘整个寄宿图就太浪费了。但是Core Animation通常并不了解你的自定义绘图代码，它也不能自己计算出脏区域的位置。然而，你的确可以提供这些信息。

  当你检测到指定视图或图层的指定部分需要被重绘，你直接调用-setNeedsDisplayInRect:来标记它，然后将影响到的矩形作为参数传入。这样就会在一次视图刷新时调用视图的-drawRect:（或图层代理的-drawLayer:inContext:方法）。

  传入-drawLayer:inContext:的CGContext参数会自动被裁切以适应对应的矩形。为了确定矩形的尺寸大小，你可以用CGContextGetClipBoundingBox()方法来从上下文获得大小。调用-drawRect()会更简单，因为CGRect会作为参数直接传入。

  你应该将你的绘制工作限制在这个矩形中。任何在此区域之外的绘制都将被自动无视，但是这样CPU花在计算和抛弃上的时间就浪费了，实在是太不值得了。

  相比依赖于Core Graphics为你重绘，裁剪出自己的绘制区域可能会让你避免不必要的操作。那就是说，如果你的裁剪逻辑相当复杂，那还是让Core Graphics来代劳吧，记住：当你能高效完成的时候才这样做。

 展示了一个-addBrushStrokeAtPoint:方法的升级版，它只重绘当前线刷的附近区域。另外也会刷新之前线刷的附近区域，我们也可以用CGRectIntersectsRect()来避免重绘任何旧的线刷以不至于覆盖已更新过的区域。这样做会显著地提高绘制效率。
   */
class DirtyRectViewController: BaseViewController {
    var dirtyRectView: DirtyRectView!

    override func viewDidLoad() {
        super.viewDidLoad()
        dirtyRectView = DirtyRectView(frame: view.bounds)
        dirtyRectView.backgroundColor = UIColor(red: 191 / 256, green: 191 / 256, blue: 191 / 256, alpha: 1.0)
        view.addSubview(dirtyRectView)
    }
}

let BRUSH_SIZE: CGFloat = 32

class DirtyRectView: UIView {
    var strokes = [NSValue]()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    func addBrushStrokeAtPoint(_ point: CGPoint) {
        strokes.append(NSValue(cgPoint: point))
        setNeedsDisplay()
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        for item in strokes {
            let point = item.cgPointValue
            let brushRect = CGRect(x: point.x - BRUSH_SIZE / 2, y: point.y - BRUSH_SIZE / 2, width: BRUSH_SIZE, height: BRUSH_SIZE)
            UIImage(named: "chalk2")?.draw(in: brushRect)
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let point = touch.location(in: self)
            addBrushStrokeAtPoint(point)
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let point = touch.location(in: self)
            addBrushStrokeAtPoint(point)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
