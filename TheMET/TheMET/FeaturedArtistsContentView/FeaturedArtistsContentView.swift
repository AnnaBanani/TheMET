//
//  FeaturedArtistsContentView.swift
//  TheMET
//
//  Created by Анна Ситникова on 07/11/2023.
//

import Foundation
import UIKit

class FeaturedArtistsContentView: UIView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var content: [FeaturedArtistsCellData] = [] {
        didSet {
            self.collectionView.reloadData()
        }
    }
    private let imageLoader = ImageLoader()
    
    var onFeaturedArtistsCellTap: (_ artistID: Int) -> Void = { _ in }
    
    static let xibFileName = "FeaturedArtistsContentView"
    static let cellIdentifier = "CatalogCell"
    
    var onFeaturedArtistsCellWillDisplay: (_ artistID: Int) -> Void = { _ in }
    
    @IBOutlet var collectionView: UICollectionView!
    
    var flowLayout: UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: self.bounds.width * 0.5, height: 180)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 10
        return layout
    }
    
    static func constructView() -> FeaturedArtistsContentView {
        let nib = UINib(nibName: FeaturedArtistsContentView.xibFileName, bundle: nil)
        return nib.instantiate(withOwner: nil).first as! FeaturedArtistsContentView
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectionView.register(CatalogCell.self, forCellWithReuseIdentifier: FeaturedArtistsContentView.cellIdentifier)
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
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeaturedArtistsContentView.cellIdentifier, for: indexPath) as? CatalogCell else {
            print ("Error")
            return UICollectionViewCell()
        }
        let cellContent = self.content[indexPath.row]
        cell.tag = cellContent.artistId
        switch cellContent.artistData {
        case .placeholder:
            cell.isPlaceholderVisible = true
        case .data(let imageURL, let title, let subTitle):
            cell.isPlaceholderVisible = false
            cell.title = title
            cell.subtitle = subTitle
            cell.backgroundState = .loading
            if let imageURL = imageURL {
                self.imageLoader.loadImage(urlString: imageURL.absoluteString) { image in
                    guard cell.tag == cellContent.artistId else { return }
                    if let image = image {
                        cell.backgroundState = .loaded(image)
                    } else {
                        cell.backgroundState = .failed
                    }
                }
            } else {
                cell.backgroundState = .failed
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.collectionView.deselectItem(at: indexPath, animated: true)
        let cellData = self.content[indexPath.row]
        self.onFeaturedArtistsCellTap(cellData.artistId)
    }
  
    func collectionView(_: UICollectionView, willDisplay: UICollectionViewCell, forItemAt: IndexPath) {
        let cellData = self.content[forItemAt.row]
        self.onFeaturedArtistsCellWillDisplay(cellData.artistId)
    }
}
