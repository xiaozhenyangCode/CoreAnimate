//
//  CoreAnimateTableViewController.swift
//  CoreAnimate
//
//  Created by heiyanmacmini on 2020/9/15.
//  Copyright © 2020 heiyanmacmini. All rights reserved.
//

import UIKit

class CoreAnimateTableViewController: UITableViewController {
    var textLabelString: [String]!
    var classNames: [String]!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
        textLabelString = ["锚点", "HitTest",
                           "圆角", "图层边框",
                           "阴影", "ShadowPath",
                           "图层蒙板", "拉伸过滤",
                           "组透明", "仿射变换",
                           "3D变换", "固体对象"]
        classNames = ["TimerViewController", "HitTestViewController",
                      "CornerRadiusViewController", "LayerFrameViewController",
                      "ShadowViewController", "ShadowPathViewController",
                      "LayermaskViewController", "TensilefilterViewController",
                      "GroupOfTransparentViewController", "TransformViewController",
                      "Transform3DViewController", "SolidObjectViewController"]
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return textLabelString.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        cell.textLabel?.text = textLabelString[indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let ctrl = classFromString(classNames[indexPath.row]) else { return }
        navigationController?.pushViewController(ctrl, animated: true)
    }
}
