//
//  TextLayerViewController.swift
//  CoreAnimate
//
//  Created by heiyanmacmini on 2020/9/16.
//  Copyright © 2020 heiyanmacmini. All rights reserved.
//

import UIKit
/**
 CATextLayer

 用户界面是无法从一个单独的图片里面构建的。一个设计良好的图标能够很好地表现一个按钮或控件的意图，不过你迟早都要需要一个不错的老式风格的文本标签。

 如果你想在一个图层里面显示文字，完全可以借助图层代理直接将字符串使用Core Graphics写入图层的内容（这就是UILabel的精髓）。如果越过寄宿于图层的视图，直接在图层上操作，那其实相当繁琐。你要为每一个显示文字的图层创建一个能像图层代理一样工作的类，还要逻辑上判断哪个图层需要显示哪个字符串，更别提还要记录不同的字体，颜色等一系列乱七八糟的东西。

 万幸的是这些都是不必要的，Core Animation提供了一个CALayer的子类CATextLayer，它以图层的形式包含了UILabel几乎所有的绘制特性，并且额外提供了一些新的特性。

 同样，CATextLayer也要比UILabel渲染得快得多。很少有人知道在iOS 6及之前的版本，UILabel其实是通过WebKit来实现绘制的，这样就造成了当有很多文字的时候就会有极大的性能压力。而CATextLayer使用了Core text，并且渲染得非常快。
 如果你仔细看这个文本，你会发现一个奇怪的地方：这些文本有一些像素化了。这是因为并没有以Retina的方式渲染，第二章提到了这个contentScale属性，用来决定图层内容应该以怎样的分辨率来渲染。contentsScale并不关心屏幕的拉伸因素而总是默认为1.0。
 CATextLayer的font属性不是一个UIFont类型，而是一个CFTypeRef类型。这样可以根据你的具体需要来决定字体属性应该是用CGFontRef类型还是CTFontRef类型（Core Text字体）。同时字体大小也是用fontSize属性单独设置的，因为CTFontRef和CGFontRef并不像UIFont一样包含点大小。这个例子会告诉你如何将UIFont转换成CGFontRef。

 另外，CATextLayer的string属性并不是你想象的NSString类型，而是id类型。这样你既可以用NSString也可以用NSAttributedString来指定文本了（注意，NSAttributedString并不是NSString的子类）。属性化字符串是iOS用来渲染字体风格的机制，它以特定的方式来决定指定范围内的字符串的原始信息，比如字体，颜色，字重，斜体等。

 富文本

 iOS 6中，Apple给UILabel和其他UIKit文本视图添加了直接的属性化字符串的支持，应该说这是一个很方便的特性。不过事实上从iOS3.2开始CATextLayer就已经支持属性化字符串了。这样的话，如果你想要支持更低版本的iOS系统，CATextLayer无疑是你向界面中增加富文本的好办法，而且也不用去跟复杂的Core Text打交道，也省了用UIWebView的麻烦。

 让我们编辑一下示例使用到NSAttributedString（见清单6.3）.iOS 6及以上我们可以用新的NSTextAttributeName实例来设置我们的字符串属性，但是练习的目的是为了演示在iOS 5及以下，所以我们用了Core Text，也就是说你需要把Core Text framework添加到你的项目中。否则，编译器是无法识别属性常量的。
 */
class TextLayerViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let labelView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        view.addSubview(labelView)
        labelView.center = CGPoint(x: view.center.x, y: 300)

        let textLayer = CATextLayer()
        textLayer.frame = labelView.bounds
        labelView.layer.addSublayer(textLayer)

        textLayer.foregroundColor = UIColor.black.cgColor
        textLayer.alignmentMode = .justified
        textLayer.isWrapped = true
        let font = UIFont.systemFont(ofSize: 15)
        let fontRef = CGFont(font.fontName as CFString)
        textLayer.font = fontRef
        textLayer.fontSize = font.pointSize
        textLayer.contentsScale = UIScreen.main.scale

        let text = "https://github.com/xiaozhenyangCode"
        textLayer.string = text

        let attrLabelView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        view.addSubview(attrLabelView)
        attrLabelView.center = CGPoint(x: view.center.x, y: 500)

        let attrTextLayer = CATextLayer()
        attrTextLayer.frame = attrLabelView.bounds
        attrLabelView.layer.addSublayer(attrTextLayer)

        attrTextLayer.alignmentMode = .justified
        attrTextLayer.isWrapped = true
        attrTextLayer.contentsScale = UIScreen.main.scale

        let attrString = NSMutableAttributedString(string: text)

        var attais = [kCTForegroundColorAttributeName: UIColor.black.cgColor,
                      kCTFontAttributeName: fontRef!] as [CFString: Any]

        attrString.setAttributes(attais as [NSAttributedString.Key: Any], range: NSRange(location: 0, length: attrString.length))

        attais = [kCTForegroundColorAttributeName: UIColor.red.cgColor,
                  kCTUnderlineColorAttributeName: UIColor.blue.cgColor,
                  kCTUnderlineStyleAttributeName: CTUnderlineStyle.single,
                  kCTFontAttributeName: fontRef!] as [CFString: Any]
        
        attrString.setAttributes(attais as [NSAttributedString.Key: Any], range: NSRange(location: 19, length: 16))

        attrTextLayer.string = attrString
    }
}
