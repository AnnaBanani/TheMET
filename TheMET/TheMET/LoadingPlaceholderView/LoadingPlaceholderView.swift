//
//  LoadingPlaceholderView.swift
//  TheMET
//
//  Created by Анна Ситникова on 18/04/2023.
//

import Foundation
import UIKit

class LoadingPlaceholderView: UIView {
    
    static let xibFileName = "LoadingPlaceholderView"
    
    var onButtonTap: () -> Void = {}
    
    @IBOutlet var textLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var button: UIButton!
    
    static func constructView(configuration: LoadingPlaceholderConfiguration) -> LoadingPlaceholderView {
        let nib = UINib(nibName: LoadingPlaceholderView.xibFileName, bundle: nil)
        let view = nib.instantiate(withOwner: nil).first as! LoadingPlaceholderView
        view.setup(configuration: configuration)
        return view
    }
    
    private func setup(configuration: LoadingPlaceholderConfiguration) {
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

struct LoadingPlaceholderConfiguration {
    
    let text: String
    let image: UIImage?
    let buttonTitle: String?
    
    static let featuredFailed: LoadingPlaceholderConfiguration = LoadingPlaceholderConfiguration(text: NSLocalizedString("artwork.loading_failed", comment: ""), image: UIImage(named: "No Connection"), buttonTitle: NSLocalizedString("artwork.load_again_cta", comment: ""))
    static let featuredLoading: LoadingPlaceholderConfiguration = LoadingPlaceholderConfiguration(text: NSLocalizedString("featured_artwork.loading", comment: ""), image: UIImage(named: "Frame"), buttonTitle: NSLocalizedString("featured_artwork.load_next_cta", comment: ""))
    static let catalogLoading: LoadingPlaceholderConfiguration = LoadingPlaceholderConfiguration(text: NSLocalizedString("category_artworks.loading", comment: ""), image: UIImage(named: "HangingPictures"), buttonTitle: nil)
    static let catalogFailed: LoadingPlaceholderConfiguration = LoadingPlaceholderConfiguration(text: NSLocalizedString("catalog.loading_failed", comment: ""), image: UIImage(named: "No Connection"), buttonTitle: NSLocalizedString("artwork.load_again_cta", comment: ""))
    static let categoryArtworksLoading: LoadingPlaceholderConfiguration =  LoadingPlaceholderConfiguration(text: NSLocalizedString("category_artworks.loading", comment: ""), image: UIImage(named: "HangingPictures"), buttonTitle: nil)
    static let categoryFailed: LoadingPlaceholderConfiguration = LoadingPlaceholderConfiguration(text: NSLocalizedString("catalog.loading_failed", comment: ""), image: UIImage(named: "No Connection"), buttonTitle: NSLocalizedString("artwork.load_again_cta", comment: ""))
    
}
