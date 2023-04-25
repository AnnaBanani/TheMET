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
        textLabel.text = "Please wait while we choose a masterpiece"
        textLabel.textColor = UIColor(red: 188.0/255, green: 176.0/255, blue: 193.0/255, alpha: 1)
        imageView.image = UIImage(named: "Frame")
        button.backgroundColor = UIColor(red: 134.0/255, green: 121.0/255, blue: 139.0/255, alpha: 1)
        button.layer.cornerRadius = 30
        var buttonAttributed: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor: UIColor(red: 242.0/255, green: 242.0/255, blue: 242.0/255, alpha: 1)
        ]
        let buttonTitle: String = "Generate new artwork"
        let attributedNexttButtonString = NSAttributedString(string: buttonTitle, attributes: buttonAttributed)
        button.setAttributedTitle(attributedNexttButtonString, for: .normal)
    }
}

