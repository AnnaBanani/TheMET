//
//  FailedToLoadViewq.swift
//  TheMET
//
//  Created by Анна Ситникова on 25/04/2023.
//

import Foundation
import UIKit

class FailedToLoadView: UIView{
    
    static let xibFileName = "FailedToLoadView"
    
    @IBOutlet var textLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var button: UIButton!
    
    static func constructView() -> FailedToLoadView {
        let nib = UINib(nibName: FailedToLoadView.xibFileName, bundle: nil)
        return nib.instantiate(withOwner: nil).first as! FailedToLoadView
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imageView.image = UIImage(named: "No Connection")
        self.textLabel.apply(font: NSLocalizedString("serif_font", comment: ""), color: UIColor(named: "plum"), fontSize: 18, title: NSLocalizedString("featured_artwork.loading_failed", comment: ""))
        self.button.apply(backgroundColor: UIColor(named: "blueberry"), fontColor: UIColor(named: "pear"), font: NSLocalizedString("san_serif_font", comment: ""), fontSize: 20, buttonTitle: NSLocalizedString("featured_artwork.load_again_cta", comment: ""))
    }
}
