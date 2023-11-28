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
    
    var onFeaturedArtistsCellTap: (_ artistName: String) -> Void = { _ in }
    
    static let xibFileName = "FeaturedArtistsContentView"
    static let cellIdentifier = "CatalogCell"
    
    var onFeaturedArtistsCellWillDisplay: (_ artistName: String) -> Void = { _ in }
    
    @IBOutlet var collectionView: UICollectionView!
    
    var flowLayout: UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        let width = (self.bounds.width - 30)/2
        layout.itemSize = CGSize(width: width, height: 180)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        return layout
    }
    
    static func constructView() -> FeaturedArtistsContentView {
        let nib = UINib(nibName: FeaturedArtistsContentView.xibFileName, bundle: nil)
        return nib.instantiate(withOwner: nil).first as! FeaturedArtistsContentView
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectionView.register(CatalogCell.self, forCellWithReuseIdentifier: FeaturedArtistsContentView.cellIdentifier)
        self.collectionView.backgroundColor = UIColor(named: "blackberry")
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
        switch cellContent.artistData {
        case .placeholder:
            cell.title = ""
            cell.subtitle = ""
            cell.backgroundState = .loading
            cell.backgroundImageURL = nil
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
                        cell.backgroundState = .failed(.noInternet)
                    }
                }
            } else {
                cell.backgroundState = .failed(.noInternet)
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.collectionView.deselectItem(at: indexPath, animated: true)
        let cellData = self.content[indexPath.row]
        self.onFeaturedArtistsCellTap(cellData.artistName)
    }
  
    func collectionView(_: UICollectionView, willDisplay: UICollectionViewCell, forItemAt: IndexPath) {
        let cellData = self.content[forItemAt.row]
        self.onFeaturedArtistsCellWillDisplay(cellData.artistName)
    }
}
