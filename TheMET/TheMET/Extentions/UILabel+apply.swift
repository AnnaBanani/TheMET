//
//  UILabel+apply.swift
//  TheMET
//
//  Created by Анна Ситникова on 11/05/2023.
//

import Foundation
import UIKit

extension UILabel {
    func apply(font: String, color: UIColor?, alignment: NSTextAlignment = .center, fontSize: Double, title: String) {
        var labelAttributes: [NSAttributedString.Key: Any] = [ : ]
        let labelfontName = font
        if let labelFont: UIFont = UIFont(name: labelfontName, size: fontSize),
           let color: UIColor = color {
            labelAttributes[.font] = labelFont
            labelAttributes[.foregroundColor] = color
            if labelfontName == "Quattrocento" {
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.lineHeightMultiple = 1.3
                paragraphStyle.alignment = alignment
                labelAttributes[.paragraphStyle] = paragraphStyle
            }
        }
        let attribuesString = NSMutableAttributedString(string: title, attributes: labelAttributes)
        self.attributedText = attribuesString
    }
}
