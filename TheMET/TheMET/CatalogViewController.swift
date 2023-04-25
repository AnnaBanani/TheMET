//
//  CatalogViewController.swift
//  TheMET
//
//  Created by Анна Ситникова on 21/03/2023.
//

import Foundation
import UIKit


class CatalogViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let newView = FailedToLoadView.constructView()
        newView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(newView)
        NSLayoutConstraint.activate([
            newView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
            newView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
            newView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0),
            newView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0)
        ])
    }
    
}

