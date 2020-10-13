//
//  LayePropertiesTableViewController.swift
//  CoreAnimate
//
//  Created by heiyanmini on 2020/10/12.
//  Copyright © 2020 heiyanmacmini. All rights reserved.
//

import UIKit

class LayePropertiesTableViewController: BaseTableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        textLabelString = ["隐式绘制", "离屏渲染", "混合和过度绘制", "减少图层数量"]

        classNames = ["ImplicitMappingViewController", "OffScreenRenderingViewController", "MixAndOverdrawViewController", "ReduceNumberLayersViewController"]
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
