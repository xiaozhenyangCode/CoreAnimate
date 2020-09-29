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
