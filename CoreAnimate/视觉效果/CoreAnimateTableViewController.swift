//
//  CoreAnimateTableViewController.swift
//  CoreAnimate
//
//  Created by heiyanmacmini on 2020/9/15.
//  Copyright © 2020 heiyanmacmini. All rights reserved.
//

import UIKit

class CoreAnimateTableViewController: BaseTableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        textLabelString = ["锚点", "HitTest",
                           "圆角", "图层边框",
                           "阴影", "ShadowPath",
                           "图层蒙板", "拉伸过滤"]
        classNames = ["TimerViewController", "HitTestViewController",
                      "CornerRadiusViewController", "LayerFrameViewController",
                      "ShadowViewController", "ShadowPathViewController",
                      "LayermaskViewController", "TensilefilterViewController"]
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
