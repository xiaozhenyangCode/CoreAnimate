//
//  EfficientMappingTableViewController.swift
//  CoreAnimate
//
//  Created by heiyanmini on 2020/9/29.
//  Copyright © 2020 heiyanmacmini. All rights reserved.
//

import UIKit

class EfficientMappingTableViewController: BaseTableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        textLabelString = ["软件绘图", "矢量图形", "脏矩形"]

        classNames = ["DrawingSoftwareViewController", "VectorGraphicsViewController", "DirtyRectViewController"]
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
