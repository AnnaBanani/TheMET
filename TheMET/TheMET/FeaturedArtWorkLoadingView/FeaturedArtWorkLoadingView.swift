//
//  FeaturedArtWorkLoadingView.swift
//  TheMET
//
//  Created by Анна Ситникова on 18/04/2023.
//

import Foundation
import UIKit

class FeaturedArtWorkLoadingView: UIView {
    
    static let xibFileName = "FeaturedArtWorkLoadingView"
    
    @IBOutlet var textLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var button: UIButton!
    
    static func constructView() -> FeaturedArtWorkLoadingView {
        let nib = UINib(nibName: FeaturedArtWorkLoadingView.xibFileName, bundle: nil)
        return nib.instantiate(withOwner: nil).first as! FeaturedArtWorkLoadingView
        }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imageView.image = UIImage(named: "Frame")
        self.textLabel.apply(font: NSLocalizedString("serif_font", comment: ""), color: UIColor(named: "plum"), fontSize: 18, title: NSLocalizedString("featured_artwork.loading", comment: ""))
        self.button.apply(backgroundColor: UIColor(named: "blueberry"), fontColor: UIColor(named: "pear"), font: NSLocalizedString("san_serif_font", comment: ""), fontSize: 20, buttonTitle: NSLocalizedString("featured_artwork.load_next_cta", comment: ""))
    }
}

