//
//  LayerLabel.swift
//  CoreAnimate
//
//  Created by heiyanmini on 2020/9/18.
//  Copyright © 2020 heiyanmacmini. All rights reserved.
//

import Foundation
import UIKit
class LayerLabel: UILabel {
    override class var layerClass: AnyClass {
        return CATextLayer.self
    }

    func textLayer() -> CATextLayer {
        return layer as! CATextLayer
    }

    func setup() {
        text = text
        textColor = textColor
        font = font

        textLayer().alignmentMode = .justified
        textLayer().isWrapped = true
        layer.display()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    func setText(_ text: String) {
        super.text = text
        textLayer().string = text
    }

    func setTextColor(_ textColor: UIColor) {
        super.textColor = textColor
        textLayer().foregroundColor = textColor.cgColor
    }

    func setFont(_ font: UIFont) {
        super.font = font
        let fontRef = CGFont(font.fontName as CFString)
        textLayer().font = fontRef
        textLayer().fontSize = font.pointSize
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
