//
//  VectorGraphicsViewController.swift
//  CoreAnimate
//
//  Created by heiyanmini on 2020/9/29.
//  Copyright © 2020 heiyanmacmini. All rights reserved.
//

import UIKit
/**
  矢量图形

  我们用Core Graphics来绘图的一个通常原因就是只是用图片或是图层效果不能轻易地绘制出矢量图形。矢量绘图包含一下这些：

 任意多边形（不仅仅是一个矩形）
 斜线或曲线
 文本
 渐变
  举个例子，展示了一个基本的画线应用。这个应用将用户的触摸手势转换成一个UIBezierPath上的点，然后绘制成视图。我们在一个UIView子类DrawingView中实现了所有的绘制逻辑，这个情况下我们没有用上view controller。但是如果你喜欢你可以在view controller中实现触摸事件处理。

 这样实现的问题在于，我们画得越多，程序就会越慢。因为每次移动手指的时候都会重绘整个贝塞尔路径（UIBezierPath），随着路径越来越复杂，每次重绘的工作就会增加，直接导致了帧数的下降。看来我们需要一个更好的方法了。

   Core Animation为这些图形类型的绘制提供了专门的类，并给他们提供硬件支持（第六章『专有图层』有详细提到）。CAShapeLayer可以绘制多边形，直线和曲线。CATextLayer可以绘制文本。CAGradientLayer用来绘制渐变。这些总体上都比Core Graphics更快，同时他们也避免了创造一个寄宿图。

   如果稍微将之前的代码变动一下，用CAShapeLayer替代Core Graphics，性能就会得到提高（见清单13.2）.虽然随着路径复杂性的增加，绘制性能依然会下降，但是只有当非常非常浮躁的绘制时才会感到明显的帧率差异。
 */
class VectorGraphicsViewController: BaseViewController {
    var drawingView: DrawingView!
    var drawingCAShapeLayerView: DrawingCAShapeLayerView!

    override func viewDidLoad() {
        super.viewDidLoad()

//        drawingView = DrawingView(frame: view.bounds)
//        drawingView.backgroundColor = UIColor(red: 191 / 256, green: 191 / 256, blue: 191 / 256, alpha: 1.0)
//        view.addSubview(drawingView)

        drawingCAShapeLayerView = DrawingCAShapeLayerView(frame: view.bounds)
        drawingCAShapeLayerView.backgroundColor = UIColor(red: 191 / 256, green: 191 / 256, blue: 191 / 256, alpha: 1.0)
        view.addSubview(drawingCAShapeLayerView)
    }
}

class DrawingView: UIView {
    var path = UIBezierPath()
    override init(frame: CGRect) {
        super.init(frame: frame)
        path.lineJoinStyle = .round
        path.lineCapStyle = .round
        path.lineWidth = 5
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        UIColor.clear.setFill()
        UIColor.red.setStroke()
        path.stroke()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let point = touch.location(in: self)
            path.move(to: point)
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let point = touch.location(in: self)
            path.addLine(to: point)
        }
        setNeedsDisplay()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class DrawingCAShapeLayerView: UIView {
    var path = UIBezierPath()
    override init(frame: CGRect) {
        super.init(frame: frame)
        let shapeLayer = layer as! CAShapeLayer
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineJoin = .round
        shapeLayer.lineCap = .round
        shapeLayer.lineWidth = 5
    }

    override class var layerClass: AnyClass {
        return CAShapeLayer.self
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let point = touch.location(in: self)
            path.move(to: point)
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let point = touch.location(in: self)
            path.addLine(to: point)
        }
        (layer as! CAShapeLayer).path = path.cgPath
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
