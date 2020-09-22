//
//  AVPlayerLayerViewController.swift
//  CoreAnimate
//
//  Created by heiyanmini on 2020/9/22.
//  Copyright © 2020 heiyanmacmini. All rights reserved.
//

/**
 AVPlayerLayer
 AVPlayerLayer。尽管它不是Core Animation框架的一部分（AV前缀看上去像），AVPlayerLayer是有别的框架（AVFoundation）提供的，它和Core Animation紧密地结合在一起，提供了一个CALayer子类来显示自定义的内容类型。

 AVPlayerLayer是用来在iOS上播放视频的。他是高级接口例如MPMoivePlayer的底层实现，提供了显示视频的底层控制。AVPlayerLayer的使用相当简单：你可以用+playerLayerWithPlayer:方法创建一个已经绑定了视频播放器的图层，或者你可以先创建一个图层，然后用player属性绑定一个AVPlayer实例。

 我们用代码创建了一个AVPlayerLayer，但是我们仍然把它添加到了一个容器视图中，而不是直接在controller中的主视图上添加。这样其实是为了可以使用自动布局限制使得图层在最中间；否则，一旦设备被旋转了我们就要手动重新放置位置，因为Core Animation并不支持自动大小和自动布局（见第三章『图层几何学』）。

 当然，因为AVPlayerLayer是CALayer的子类，它继承了父类的所有特性。我们并不会受限于要在一个矩形中播放
 */
import AVFoundation
import UIKit
class AVPlayerLayerViewController: BaseViewController {
    var player: AVPlayer!

    override func viewDidLoad() {
        super.viewDidLoad()
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        view.addSubview(containerView)
        containerView.center = view.center

        let url = Bundle.main.path(forResource: "1111", ofType: "MP4")

        player = AVPlayer(url: URL(fileURLWithPath: url!))
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = containerView.bounds
        playerLayer.videoGravity = .resizeAspect
        containerView.layer.addSublayer(playerLayer)

        // 在3D，圆角，有色边框，蒙板，阴影等效果

        var transform = CATransform3DIdentity
        transform.m34 = -1.0 / 500
        transform = CATransform3DRotate(transform, CGFloat(Double.pi / 4), -1, -1, 0)
        playerLayer.transform = transform
        
        playerLayer.masksToBounds = true
        playerLayer.cornerRadius = 20
        playerLayer.borderColor = arcrandomColor().cgColor
        playerLayer.borderWidth = 5
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        player.play()
    }
}
