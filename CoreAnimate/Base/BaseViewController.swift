//
//  BaseViewController.swift
//  CoreAnimate
//
//  Created by heiyanmacmini on 2020/9/15.
//  Copyright © 2020 heiyanmacmini. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
    }

    deinit {
        printf("\(className) 页面销毁")
    }
}
