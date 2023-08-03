//
//  UISearchBar+apply.swift
//  TheMET
//
//  Created by Анна Ситникова on 03/08/2023.
//

import Foundation
import UIKit

extension UISearchBar {
    
    func apply(barTintColor: UIColor?,  textFieldBackgroundColor: UIColor?, textFieldColor: UIColor?) {
        if let barTintColor = barTintColor,
           let textFieldBackgroundColor = textFieldBackgroundColor,
           let textFieldColor = textFieldColor,
           let textField = self.value(forKey: "searchField") as? UITextField {
            self.barTintColor = barTintColor
            self.searchTextField.backgroundColor = textFieldBackgroundColor
            self.searchTextField.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("search", comment: ""), attributes: [NSAttributedString.Key.foregroundColor: textFieldColor])
            textField.textColor = textFieldColor
            let glassIconView = textField.leftView as! UIImageView
            glassIconView.image = glassIconView.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
            glassIconView.tintColor = textFieldColor
            let clearButton = textField.value(forKey: "clearButton") as! UIButton
            clearButton.setImage(clearButton.imageView?.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
            clearButton.tintColor = textFieldColor
        }
    }
    
}
