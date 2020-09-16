//
//  TimerViewController.swift
//  CoreAnimate
//
//  Created by heiyanmacmini on 2020/9/15.
//  Copyright © 2020 heiyanmacmini. All rights reserved.
//

import UIKit

class TimerViewController: BaseViewController {
    var timeImageView: UIImageView!
    var hourImageView: UIImageView!
    var minuteImageView: UIImageView!
    var secondImageView: UIImageView!
    var timer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()

        timeImageView = UIImageView(image: UIImage(named: "time"))
        view.addSubview(timeImageView)
        timeImageView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.width)
        timeImageView.center = view.center

        hourImageView = UIImageView(image: UIImage(named: "time_h"))
        view.addSubview(hourImageView)
        hourImageView.center = timeImageView.center

        minuteImageView = UIImageView(image: UIImage(named: "time_m"))
        view.addSubview(minuteImageView)
        minuteImageView.center = timeImageView.center

        secondImageView = UIImageView(image: UIImage(named: "time_s"))
        view.addSubview(secondImageView)
        secondImageView.center = timeImageView.center

        hourImageView.layer.anchorPoint = CGPoint(x: 0.5, y: 0.9)
        minuteImageView.layer.anchorPoint = CGPoint(x: 0.5, y: 0.9)
        secondImageView.layer.anchorPoint = CGPoint(x: 0.5, y: 0.9)

        timer = Timer.scheduledTimer(timeInterval: 1.0, target: Proxy(self), selector: #selector(tick), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: .common)
        tick()
    }

    @objc func tick() {
        let calender = Calendar(identifier: .gregorian)
        let components = calender.dateComponents([.hour, .minute, .second], from: Date())
        let hoursAngle = (Double(components.hour ?? 0) / 12) * Double.pi * 2.0
        let minsAngle = (Double(components.minute ?? 0) / 60) * Double.pi * 2.0
        let secsAngle = (Double(components.second ?? 0) / 60) * Double.pi * 2.0

        hourImageView.transform = CGAffineTransform(rotationAngle: CGFloat(hoursAngle))
        minuteImageView.transform = CGAffineTransform(rotationAngle: CGFloat(minsAngle))
        secondImageView.transform = CGAffineTransform(rotationAngle: CGFloat(secsAngle))
    }

    deinit {
        timer?.fireDate = Date.distantFuture
        timer?.invalidate()
        timer = nil
    }
}
