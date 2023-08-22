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
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.backgroundColor = .clear
        let backItemAppearance = UIBarButtonItemAppearance()
        var image = UIImage()
        if let color: UIColor = color,
           let font: UIFont = UIFont(name: fontName, size: fontSize),
           let chevronImage = UIImage(systemName: "chevron.backward"){
            navigationBarAppearance.titleTextAttributes = [
                NSAttributedString.Key.foregroundColor: color,
                NSAttributedString.Key.font: font
            ]
            backItemAppearance.normal.titleTextAttributes = [.foregroundColor : color]
            image = chevronImage.withTintColor(color, renderingMode: .alwaysOriginal)
        }
        navigationBarAppearance.setBackIndicatorImage(image, transitionMaskImage: image)
        navigationBarAppearance.backButtonAppearance = backItemAppearance
        return navigationBarAppearance
    }
}


