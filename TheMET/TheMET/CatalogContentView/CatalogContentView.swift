//
//  CatalogContentView.swift
//  TheMET
//
//  Created by Анна Ситникова on 10/05/2023.
//

import Foundation
import UIKit

class CatalogContentView: UIView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    static let xibFileName = "CatalogContentView"
    static let cellIdentifier = "CatalogCell"
    
    @IBOutlet var label: UILabel!
    @IBOutlet var collectionView: UICollectionView!
    
    var flowLayout: UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 130 , height: 180)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        return layout
    }
    
    static func constructView() -> CatalogContentView {
        let nib = UINib(nibName: CatalogContentView.xibFileName, bundle: nil)
        return nib.instantiate(withOwner: nil).first as! CatalogContentView
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.label.apply(font: NSLocalizedString("serif_font", comment: ""), color: UIColor(named: "pear"), fontSize: 16, title: NSLocalizedString("catalog_screen_departments_section_title", comment: ""))
        self.collectionView.register(CatalogCell.self, forCellWithReuseIdentifier: CatalogContentView.cellIdentifier)
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.collectionViewLayout = self.flowLayout
    }
    
    
    // UICollectionViewDelegate
    // UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CatalogContentView.cellIdentifier, for: indexPath) as? CatalogCell {
            cell.backgroundColor = .white
            cell.title = "Title \(indexPath.row)"
            cell.subtitle = "Subtitle \(indexPath.row)"
            switch indexPath.row % 3 {
            case 0: cell.backgroundState = .loading
            case 1: cell.backgroundState = .loaded(UIImage(named: "Image2")!)
            default: cell.backgroundState = .loaded(UIImage(named: "Image1")!)
            }
            return cell
        } else {
            print ("Error")
            return UICollectionViewCell()
        }
    }
}
