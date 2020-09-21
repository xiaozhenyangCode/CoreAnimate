//
//  SpecialLayerTableViewController.swift
//  CoreAnimate
//
//  Created by heiyanmacmini on 2020/9/16.
//  Copyright © 2020 heiyanmacmini. All rights reserved.
//

import UIKit

class SpecialLayerTableViewController: BaseTableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        textLabelString = ["CAShapeLayer", "CATextLayer", "CATransformLayer", "CAGradientLayer", "CAReplicatorLayer", "CAScrollLayer"]
        classNames = ["ShapeLayerViewController", "TextLayerViewController", "TransformLayerViewCtrl", "GradientLayerViewCtrl", "ReplicatorLayerViewController", "ScrollLayerViewController"]
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
