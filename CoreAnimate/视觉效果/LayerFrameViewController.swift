//
//  LayerFrameViewController.swift
//  CoreAnimate
//
//  Created by heiyanmacmini on 2020/9/15.
//  Copyright © 2020 heiyanmacmini. All rights reserved.
//

import UIKit

class LayerFrameViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let layerView1 = UIView(frame: CGRect(x: 100, y: 150, width: 200, height: 200))
        layerView1.backgroundColor = .red
        layerView1.layer.cornerRadius = 20
        view.addSubview(layerView1)

        let layerView2 = UIView(frame: CGRect(x: 50, y: 50, width: 200, height: 200))
        layerView2.backgroundColor = .blue
        layerView2.layer.cornerRadius = 20
        layerView1.addSubview(layerView2)

        let layerView3 = UIView(frame: CGRect(x: 100, y: 500, width: 200, height: 200))
        layerView3.backgroundColor = .red
        layerView3.layer.masksToBounds = true
        layerView3.layer.cornerRadius = 20
        view.addSubview(layerView3)

        let layerView4 = UIView(frame: CGRect(x: 50, y: 50, width: 200, height: 200))
        layerView4.backgroundColor = .blue
        layerView4.layer.cornerRadius = 20
        layerView3.addSubview(layerView4)

        layerView1.layer.borderWidth = 5
        layerView2.layer.borderWidth = 5
        layerView3.layer.borderWidth = 5
        layerView4.layer.borderWidth = 5
    }
}
