//
//  itemApearence.swift
//  TheMET
//
//  Created by Анна Ситникова on 09/05/2023.
//

import Foundation
import UIKit
    
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
