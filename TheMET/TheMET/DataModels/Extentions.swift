//
//  itemApearence.swift
//  TheMET
//
//  Created by Анна Ситникова on 09/05/2023.
//

import Foundation
import UIKit
    
extension UILabel {
    func apply(font: String, color: UIColor?, fontSize: Double, title: String) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.3
        paragraphStyle.alignment = .center
        var labelAttributes: [NSAttributedString.Key: Any] = [ : ]
        let labelfontName = font
        if let labelFont: UIFont = UIFont(name: labelfontName, size: 18),
           let color: UIColor = color {
            labelAttributes[.font] = labelFont
            labelAttributes[.foregroundColor] = color
            if labelfontName == "Quattrocento" {
                labelAttributes[.paragraphStyle] = paragraphStyle
            }
        }
        let attribuesString = NSMutableAttributedString(string: title, attributes: labelAttributes)
        self.attributedText = attribuesString
    }
}

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

extension UINavigationItem {
    func apply(title: String, color: UIColor?, fontName: String, fontSize: Double) -> UINavigationBarAppearance{
        self.title = title
        let navigationBarAppearance = UINavigationBarAppearance()
        if let color: UIColor = color,
           let font: UIFont = UIFont(name: fontName, size: fontSize) {
            navigationBarAppearance.titleTextAttributes = [
                NSAttributedString.Key.foregroundColor: color,
                NSAttributedString.Key.font: font
            ]
        }
        return navigationBarAppearance
    }
}
