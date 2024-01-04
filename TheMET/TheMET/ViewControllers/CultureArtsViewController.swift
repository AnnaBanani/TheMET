//
//  CultureArtsViewController.swift
//  TheMET
//
//  Created by Анна Ситникова on 12/12/2023.
//

import Foundation
import UIKit
import Combine
import MetAPI

class CultureArtsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate  {
   
    var culture: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.standardAppearance = self.navigationItem.apply(title: NSLocalizedString("", comment: ""), color: UIColor(named: "plum"), fontName: NSLocalizedString("serif_font", comment: ""), fontSize: 22)
    }
    
    // UITableViewDelegate, UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        return cell
    }
}
