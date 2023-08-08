//
//  CategoryViewController.swift
//  TheMET
//
//  Created by Анна Ситникова on 06/07/2023.
//

import Foundation
import UIKit

class CategoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    private let metAPI = MetAPI(networkManager: NetworkManager.standard)
    
    private let favoriteService = FavoritesService.standart
    
    var departmentId: Int?
    
    private var imageLoader: ImageLoader = ImageLoader()
    
    private var loadingArtIds: [ArtID] = []
    
    private let loadingCategoryView = FailedPlaceholderView.constructView(configuration: .categoryArtworksLoading)
    private let failedCategoryView = FailedPlaceholderView.constructView(configuration: .categoryFailed)
    
    private let categoryTableView: UITableView = UITableView(frame: .zero, style: .plain)
    
    var contentStatus: LoadingStatus<[ArtCellData]> = .loading {
        didSet {
            self.updateContent()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.standardAppearance = self.navigationItem.apply(title: NSLocalizedString("", comment: ""), color: UIColor(named: "plum"), fontName: NSLocalizedString("serif_font", comment: ""), fontSize: 22)
        NotificationCenter.default.addObserver(self, selector: #selector(favoriteServiceDidChange), name: FavoritesService.didChangeFavoriteArtsNotificationName, object: nil)
        self.add(categorySubview: self.loadingCategoryView)
        self.add(categorySubview: self.failedCategoryView)
        self.add(categorySubview: self.categoryTableView)
        self.categoryTableView.separatorStyle = .none
        self.categoryTableView.estimatedRowHeight = 10
        self.categoryTableView.rowHeight = UITableView.automaticDimension
        self.categoryTableView.register(ArtViewCell.self, forCellReuseIdentifier: ArtViewCell.artViewCellIdentifier)
        self.categoryTableView.dataSource = self
        self.categoryTableView.delegate = self
        self.failedCategoryView.onButtonTap = { [weak self] in
            self?.reloadButtonDidTap()
        }
        self.updateContent()
        self.reloadCategory()
    }
    
    @objc
    private func favoriteServiceDidChange() {
        self.categoryTableView.reloadData()
    }
    
    private func updateContent() {
        switch contentStatus {
        case .failed:
            self.loadingCategoryView.isHidden = true
            self.failedCategoryView.isHidden = false
            self.categoryTableView.isHidden = true
        case .loaded:
            self.loadingCategoryView.isHidden = true
            self.failedCategoryView.isHidden = true
            self.categoryTableView.isHidden = false
        case .loading:
            self.loadingCategoryView.isHidden = false
            self.failedCategoryView.isHidden = true
            self.categoryTableView.isHidden = true
        }
        self.categoryTableView.reloadData()
    }
    
    private func add(categorySubview: UIView) {
        categorySubview.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(categorySubview)
        categorySubview.backgroundColor = .clear
        let constraints: [NSLayoutConstraint] = [
            categorySubview.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
            categorySubview.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
            categorySubview.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0),
            categorySubview.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    private func reloadButtonDidTap() {
        self.reloadCategory()
    }
    
    private func reloadCategory() {
        self.contentStatus = .loading
        self.loadArtCellDataList()
    }
    
    private func loadArtCellDataList() {
        guard let id = self.departmentId else {
            self.contentStatus = .failed
            return
        }
        self.metAPI.objects(departmentIds: [id]) { [weak self] objectsResponse in
            guard let objectsResponse = objectsResponse else {
                self?.contentStatus = .failed
                return
            }
            var artCellDataList: [ArtCellData] = []
            for artId in objectsResponse.objectIDs {
                let artCellData = ArtCellData(artID: artId, artData: .placeholder)
                artCellDataList.append(artCellData)
            }
            self?.contentStatus = .loaded(artCellDataList)
        }
    }
    
    private func loadArtCellData(artID: ArtID, completion: @escaping (ArtCellData?) -> Void) {
        self.metAPI.object(id: artID) {object in
            guard let object = object else {
                completion(nil)
                return
            }
            let artCellData = ArtCellData(artID: artID, artData: .data(art: object))
            completion(artCellData)
        }
    }
    
  
    private func loadCellImage(cell: ArtViewCell, art: Art) {
        cell.imageState = .loading
        cell.tag = art.objectID
        guard let imageURL =  art.primaryImage else {
            cell.imageState = .failed
            return
        }
        self.imageLoader.loadImage(urlString: imageURL) { [weak cell] image in
            guard let cell = cell,
                  cell.tag == art.objectID else { return }
            guard let image = image else {
                cell.imageState = .failed
                return
            }
            cell.imageState = .loaded(image)
        }
    }
    
    private func removeLoadingArtId(artId: ArtID) {
        self.loadingArtIds.removeAll { id in
            return id == artId
        }
    }
    
    private func isArtLiked(art: Art) -> Bool {
        return self.favoriteService.favoriteArts.contains(where: { favoriteArt in
            return favoriteArt.objectID == art.objectID
        })
    }
    
    private func likeButtonDidTap(cell: ArtViewCell, art: Art) {
        if cell.isLiked {
            self.favoriteService.removeArt(id: art.objectID)
        } else {
            self.favoriteService.addFavoriteArt(art)
        }
    }
    
    //  UITableViewDelegate, UITableViewDataSource
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard case .loaded(let arts) = self.contentStatus else {
            return UITableViewCell()
        }
        if let cell = tableView.dequeueReusableCell(withIdentifier: ArtViewCell.artViewCellIdentifier, for: indexPath) as? ArtViewCell {
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            let art = arts[indexPath.row]
            switch art.artData {
            case .placeholder:
                cell.tag = art.artID
                cell.isPlaceholderVisible = true
            case .data(let art):
                cell.isPlaceholderVisible = false
                self.loadCellImage(cell: cell, art: art)
                cell.isLiked = self.isArtLiked(art: art)
                cell.text = String.artDescriptionText(art: art)
                if let departmentName = art.department {
                    cell.tags = [departmentName]
                }
                cell.onLikeButtonDidTap = { [weak self] in
                    self?.likeButtonDidTap(cell: cell, art: art)
                }
            }
            return cell
        } else {
            print ("Error")
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch self.contentStatus {
        case .failed, .loading:
            return 0
        case .loaded(let arts):
            return arts.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, willDisplay: UITableViewCell, forRowAt: IndexPath) {
        guard case .loaded(let arts) = self.contentStatus else {
            return
        }
        let art = arts[forRowAt.row]
        guard case .placeholder = art.artData,
              !self.loadingArtIds.contains(art.artID) else {
            return
        }
        self.loadingArtIds.append(art.artID)
        self.loadArtCellData(artID: art.artID) { [weak self] artCellData in
            if let artCellData = artCellData,
               let contentStatus = self?.contentStatus,
               case .loaded(var artCellDataList) = contentStatus,
               let artCellDataIndex = artCellDataList.firstIndex(where: { $0.artID == art.artID}) {
                artCellDataList[artCellDataIndex] = artCellData
                self?.contentStatus = .loaded(artCellDataList)
            }
            self?.removeLoadingArtId(artId: art.artID)
        }
    }
    
}


