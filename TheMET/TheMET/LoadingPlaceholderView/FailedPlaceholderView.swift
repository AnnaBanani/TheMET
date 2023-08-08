//
//  FailedPlaceholderView.swift
//  TheMET
//
//  Created by Анна Ситникова on 18/04/2023.
//

import Foundation
import UIKit

class FailedPlaceholderView: UIView {
    
    static let xibFileName = "FailedPlaceholderView"
    
    var onButtonTap: () -> Void = {}
    
    @IBOutlet var textLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var button: UIButton!
    
    static func constructView(configuration: FailedPlaceholderConfiguration) -> FailedPlaceholderView {
        let nib = UINib(nibName: FailedPlaceholderView.xibFileName, bundle: nil)
        let view = nib.instantiate(withOwner: nil).first as! FailedPlaceholderView
        view.setup(configuration: configuration)
        return view
    }
    
    private func setup(configuration: FailedPlaceholderConfiguration) {
        self.imageView.image = configuration.image
        self.textLabel.apply(font: NSLocalizedString("serif_font", comment: ""), color: UIColor(named: "plum"), fontSize: 18, title: configuration.text)
        if let buttonTitle = configuration.buttonTitle {
            self.button.apply(radius: 30, backgroundColor: UIColor(named: "blueberry"), fontColor: UIColor(named: "pear"), font: NSLocalizedString("san_serif_font", comment: ""), fontSize: 20, buttonTitle: buttonTitle, image: nil)
            self.button.addTarget(self, action: #selector(buttonDidTap), for: .touchUpInside)
        } else {
            self.button.isHidden = true
        }
    }
    
    @objc
    private func buttonDidTap(){
        self.onButtonTap()
    }
}

struct FailedPlaceholderConfiguration {
    
    let text: String
    let image: UIImage?
    let buttonTitle: String?
    
    static let featuredFailed: FailedPlaceholderConfiguration = FailedPlaceholderConfiguration(text: NSLocalizedString("artwork.loading_failed", comment: ""), image: UIImage(named: "No Connection"), buttonTitle: NSLocalizedString("artwork.load_again_cta", comment: ""))
    static let catalogFailed: FailedPlaceholderConfiguration = FailedPlaceholderConfiguration(text: NSLocalizedString("catalog.loading_failed", comment: ""), image: UIImage(named: "No Connection"), buttonTitle: NSLocalizedString("artwork.load_again_cta", comment: ""))
    static let categoryFailed: FailedPlaceholderConfiguration = FailedPlaceholderConfiguration(text: NSLocalizedString("catalog.loading_failed", comment: ""), image: UIImage(named: "No Connection"), buttonTitle: NSLocalizedString("artwork.load_again_cta", comment: ""))
    
}
