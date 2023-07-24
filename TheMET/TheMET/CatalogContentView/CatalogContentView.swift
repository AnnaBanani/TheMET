//
//  CatalogContentView.swift
//  TheMET
//
//  Created by Анна Ситникова on 10/05/2023.
//

import Foundation
import UIKit

class CatalogContentView: UIView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var content: [CatalogCellData] = [] {
        didSet {
            self.collectionView.reloadData()
        }
    }
    private let imageLoader = ImageLoader()
    
    var onCatalogCellTap: (_ departmentId: Int) -> Void = { _ in }
    
    static let xibFileName = "CatalogContentView"
    static let cellIdentifier = "CatalogCell"
    
    @IBOutlet var label: UILabel!
    @IBOutlet var collectionView: UICollectionView!
    
    var flowLayout: UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 130 , height: 180)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
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
        return self.content.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CatalogContentView.cellIdentifier, for: indexPath) as? CatalogCell {
            cell.backgroundColor = UIColor(named: "blackberry")
            let cellContent = self.content[indexPath.row]
            cell.title = cellContent.title
            cell.subtitle = cellContent.subTitle
            cell.backgroundState = .loading
            cell.tag = cellContent.departmentId
            if let imageURL = cellContent.imageURL {
                self.imageLoader.loadImage(urlString: imageURL.absoluteString) { image in
                    guard cell.tag == cellContent.departmentId else { return }
                    if let image = image {
                        cell.backgroundState = .loaded(image)
                    } else {
                        cell.backgroundState = .failed
                    }
                }
            } else {
                cell.backgroundState = .failed
            }
            return cell
        } else {
            print ("Error")
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.collectionView.deselectItem(at: indexPath, animated: true)
        let cellData = self.content[indexPath.row]
        self.onCatalogCellTap(cellData.departmentId)
    }
    
   
}
