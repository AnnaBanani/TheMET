//
//  UIButton+apply.swift
//  TheMET
//
//  Created by Анна Ситникова on 11/05/2023.
//

import Foundation
import UIKit

extension UIButton {
    func apply(backgroundColor: UIColor?, fontColor: UIColor?, font: String, fontSize: Double, buttonTitle: String) {
        self.backgroundColor = backgroundColor
        self.layer.cornerRadius = 30
        var buttonAttributed: [NSAttributedString.Key: Any] = [ : ]
        let fontName = font
        if let font: UIFont = UIFont(name: fontName, size: fontSize),
           let color: UIColor = fontColor {
            buttonAttributed[.font] = font
            buttonAttributed[.foregroundColor] = color
            if fontName == "Zen Kaku Gothic New Regular" {
                buttonAttributed[.baselineOffset] = 7
            } else {
                buttonAttributed[.baselineOffset] = 4
            }
        }
        let buttonAttributedString = NSAttributedString(
            string: buttonTitle,
            attributes: buttonAttributed
        )
        self.setAttributedTitle(buttonAttributedString, for: .normal)
    }
}
