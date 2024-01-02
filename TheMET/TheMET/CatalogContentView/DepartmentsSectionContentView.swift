//
//  DepartmentsSectionContentView.swift
//  TheMET
//
//  Created by Анна Ситникова on 10/05/2023.
//

import Foundation
import UIKit

class DepartmentsSectionContentView: UIView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var content: [CatalogCellData] = [] {
        didSet {
            self.collectionView.reloadData()
        }
    }

    private let imageLoader = ImageLoader()
    
    var onCatalogCellTap: (_ departmentId: Int) -> Void = { _ in }
    
    
    static let xibFileName = "DepartmentsSectionContentView"
    static let cellIdentifier = "CatalogCell"
    
    var onCatalogCellWillDisplay: (_ departmentId: Int) -> Void = { _ in }
    
    @IBOutlet var collectionView: UICollectionView!
    
    var flowLayout: UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 130 , height: 180)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        return layout
    }
    
    static func constructView() -> DepartmentsSectionContentView {
        let nib = UINib(nibName: DepartmentsSectionContentView.xibFileName, bundle: nil)
        return nib.instantiate(withOwner: nil).first as! DepartmentsSectionContentView
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectionView.register(CatalogCell.self, forCellWithReuseIdentifier: DepartmentsSectionContentView.cellIdentifier)
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
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DepartmentsSectionContentView.cellIdentifier, for: indexPath) as? CatalogCell {
            let cellContent = self.content[indexPath.row]
            cell.tag = cellContent.departmentId
            switch cellContent.departmentData {
            case .placeholder:
                cell.title = ""
                cell.subtitle = ""
                cell.backgroundState = .loading
            case .data(let imageURL, let title, let subTitle):
                cell.title = title
                cell.subtitle = subTitle
                cell.backgroundState = .loading
                if let imageURL = imageURL {
                    self.imageLoader.loadImage(urlString: imageURL.absoluteString) { image in
                        guard cell.tag == cellContent.departmentId else { return }
                        if let image = image {
                            cell.backgroundState = .loaded(image)
                        } else {
                            cell.backgroundState = .failed(ArtImageLoadingError.imageCannotBeLoadedFromURL)
                        }
                    }
                } else {
                    cell.backgroundState = .failed(ArtImageLoadingError.invalidImageURL)
                }
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
  
    func collectionView(_: UICollectionView, willDisplay: UICollectionViewCell, forItemAt: IndexPath) {
        let cellData = self.content[forItemAt.row]
        self.onCatalogCellWillDisplay(cellData.departmentId)
    }
}
