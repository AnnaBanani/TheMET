//
//  FeaturedArtViewController.swift
//  TheMET
//
//  Created by Анна Ситникова on 21/03/2023.
//

import Foundation
import UIKit


class FeaturedArtViewController: UIViewController {
    
    override func viewDidLoad() {
           super.viewDidLoad()
           
        let newView = FeaturedArtWorkLoadingView.constructView()
        newView.awakeFromNib()
        self.view.addSubview(newView)
        
       }
    
}
