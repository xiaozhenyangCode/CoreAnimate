//
//  HitTestViewController.swift
//  CoreAnimate
//
//  Created by heiyanmacmini on 2020/9/15.
//  Copyright © 2020 heiyanmacmini. All rights reserved.
//

import UIKit

class HitTestViewController: BaseViewController {
    var layerView: UIView!
    var blueLayer: CALayer!

    override func viewDidLoad() {
        super.viewDidLoad()

        layerView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        layerView.backgroundColor = .red
        layerView.center = view.center
        view.addSubview(layerView)

        blueLayer = CALayer()
        blueLayer.frame = CGRect(x: 50, y: 50, width: 100, height: 100)
        blueLayer.backgroundColor = UIColor.blue.cgColor
        layerView.layer.addSublayer(blueLayer)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            let t: UITouch = touch as! UITouch
            let point = t.location(in: view)
            /// containsPoint
//            point = layerView.layer.convert(point, from: view.layer)
//            if layerView.layer.contains(point) {
//                point = blueLayer.convert(point, from: layerView.layer)
//                if blueLayer.contains(point) {
//                    addOKAlertController(ctrl: self, title: "Inside Blue Layer", message: "", okSting: "OK")
//                } else {
//                    addOKAlertController(ctrl: self, title: "Inside Red Layer", message: "", okSting: "OK")
//                }
//            }
            /// hitTest
            let layer = layerView.layer.hitTest(point)
            if layer == blueLayer {
                addOKAlertController(ctrl: self, title: "Inside Blue Layer", message: "", okSting: "OK")
            } else if layer == layerView.layer {
                addOKAlertController(ctrl: self, title: "Inside Red Layer", message: "", okSting: "OK")
            }
        }
    }
}

public func addOKAlertController(ctrl: UIViewController, title: String = "提示", message: String, okSting: String = "确定", preferredStyle: Int = 1) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style(rawValue: preferredStyle)!)
    let okAlert = UIAlertAction(title: okSting, style: .default)
    alertController.addAction(okAlert)
    ctrl.present(alertController, animated: true, completion: nil)
}
