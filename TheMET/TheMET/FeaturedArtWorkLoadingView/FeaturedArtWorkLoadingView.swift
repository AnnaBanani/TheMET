//
//  FeaturedArtWorkLoadingView.swift
//  TheMET
//
//  Created by Анна Ситникова on 18/04/2023.
//

import Foundation
import UIKit

class FeaturedArtWorkLoadingView: UIView {
    
    static let identifier = "FeaturedArtWorkLoadingView"
    

    @IBOutlet var textLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    
    static func constructView() -> FeaturedArtWorkLoadingView {
        let nib = UINib(nibName: FeaturedArtWorkLoadingView.identifier, bundle: nil)
        return nib.instantiate(withOwner: nil).first as! FeaturedArtWorkLoadingView
        }
            
    func configureImageAndText(image : UIImage, text : String) {
        textLabel.text = text
        imageView.image = image
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textLabel.text = "Please wait while we choose a masterpiece"
        textLabel.textColor = UIColor(red: 188.0/255, green: 176.0/255, blue: 193.0/255, alpha: 1)
        imageView.image = UIImage(named: "Frame")
    }

    
    
}

