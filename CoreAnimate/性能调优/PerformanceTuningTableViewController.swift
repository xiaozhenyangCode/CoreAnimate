//
//  PerformanceTuningTableViewController.swift
//  CoreAnimate
//
//  Created by heiyanmini on 2020/9/28.
//  Copyright © 2020 heiyanmacmini. All rights reserved.
//

import UIKit

class PerformanceTuningTableViewController: BaseTableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        textLabelString = ["CPU VS GPU", "测量，而不是猜测", "Instruments"]

        classNames = ["CPUVSGPUViewController", "MeasurementViewController", "InstrumentsViewController"]
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
