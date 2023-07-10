//
//  CategoryViewController.swift
//  TheMET
//
//  Created by Анна Ситникова on 06/07/2023.
//

import Foundation
import UIKit

class CategoryViewController: UIViewController {
    
    @IBOutlet
    private var cancelButon: UIButton!
    
    @IBAction
    private func cancelButtonDidTap() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
}


