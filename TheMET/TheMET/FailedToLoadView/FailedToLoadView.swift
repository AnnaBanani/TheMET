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
        textLabel.text = "Artwork cannot be upload \n \n \nMake sure you are connecting o Wi-Fi or your cellular network"
        textLabel.textColor = UIColor(red: 188.0/255, green: 176.0/255, blue: 193.0/255, alpha: 1)
        imageView.image = UIImage(named: "No Connection")
        button.backgroundColor = UIColor(red: 134.0/255, green: 121.0/255, blue: 139.0/255, alpha: 1)
        button.layer.cornerRadius = 30
        button.setTitleColor(UIColor(red: 242.0/255, green: 242.0/255, blue: 242.0/255, alpha: 1), for: .normal)
        button.setTitle("Try again", for: .normal)
    }
    
}

