//
//  UIButton+apply.swift
//  TheMET
//
//  Created by Анна Ситникова on 11/05/2023.
//

import Foundation
import UIKit

extension UIButton {
    func apply(radius: CGFloat, backgroundColor: UIColor?, fontColor: UIColor?, font: String, fontSize: Double, buttonTitle: String, image: UIImage?) {
        self.backgroundColor = backgroundColor
        self.layer.cornerRadius = radius
        if let image = image {
            self.setImage(image, for: .normal)
        } else {
            self.setImage(nil, for: .normal)
        }
        var buttonAttributed: [NSAttributedString.Key: Any] = [ : ]
        let fontName = font
        if let font: UIFont = UIFont(name: fontName, size: fontSize),
           let color: UIColor = fontColor {
            buttonAttributed[.font] = font
            buttonAttributed[.foregroundColor] = color
            if fontName == "Zen Kaku Gothic New Regular" {
                buttonAttributed[.baselineOffset] = 5
            } else {
                buttonAttributed[.baselineOffset] = 2
            }
        }
        let buttonAttributedString = NSAttributedString(
            string: buttonTitle,
            attributes: buttonAttributed
        )
        self.setAttributedTitle(buttonAttributedString, for: .normal)
    }
}
