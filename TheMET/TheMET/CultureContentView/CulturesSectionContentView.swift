//
//  CulturesSectionContentView.swift
//  TheMET
//
//  Created by Анна Ситникова on 21/12/2023.
//

import Foundation
import UIKit

class CulturesSectionContentView: UIView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var culturesContent: [CatalogSectionCellData <String>] = [] {
        didSet {
            self.collectionView.reloadData()
        }
    }
    private let imageLoader = ImageLoader()
    
    var onCultureCellTap: (_ culture: String) -> Void = { _ in }
    
    static let xibFileName = "CulturesSectionContentView"
    static let cellIdentifier = "CatalogCell"
    
    var onCultureCellWillDisplay: (_ culture: String) -> Void = { _ in }
    
    @IBOutlet var collectionView: UICollectionView!
    
    var flowLayout: UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 130 , height: 180)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        return layout
    }
    
    static func constructView() -> CulturesSectionContentView {
        let nib = UINib(nibName: CulturesSectionContentView.xibFileName, bundle: nil)
        return nib.instantiate(withOwner: nil).first as! CulturesSectionContentView
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectionView.register(CatalogCell.self, forCellWithReuseIdentifier: CulturesSectionContentView.cellIdentifier)
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.collectionViewLayout = self.flowLayout
    }
    
    
    // UICollectionViewDelegate
    // UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.culturesContent.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CulturesSectionContentView.cellIdentifier, for: indexPath) as? CatalogCell else {
            print ("Error")
            return UICollectionViewCell()
        }
        let cellContent = self.culturesContent[indexPath.row]
        switch cellContent.data {
        case .placeholder:
            cell.title = ""
            cell.subtitle = ""
            cell.backgroundState = .loading
        case .data(let imageURL, let title, let subTitle):
            cell.title = title
            cell.subtitle = subTitle
            cell.backgroundState = .loading
            cell.backgroundImageURL = imageURL
            if let imageURL = imageURL {
                self.imageLoader.loadImage(urlString: imageURL.absoluteString) { image in
                    guard cell.backgroundImageURL == imageURL else {  return }
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
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.collectionView.deselectItem(at: indexPath, animated: true)
        let cellData = self.culturesContent[indexPath.row]
        self.onCultureCellTap(cellData.sectionIdentificator)
    }
  
    func collectionView(_: UICollectionView, willDisplay: UICollectionViewCell, forItemAt: IndexPath) {
        let cellData = self.culturesContent[forItemAt.row]
        self.onCultureCellWillDisplay(cellData.sectionIdentificator)
    }
}
