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
    
    private let favoritteService = FavoritesService.standart
    
    private let loadingCategoryView = LoadingPlaceholderView.constructView(configuration: .categoryArtworksLoading)
    private let failedCategoryView = LoadingPlaceholderView.constructView(configuration: .categoryFailed)
    
    private let categoryTableView: UITableView = UITableView(frame: .zero, style: .plain)
    
    enum Status {
        case loaded([Art])
        case loading
        case failed
    }
    
    var contentStatus: Status = .loading {
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
        self.loadListOfArts { [weak self] arts in
            guard let arts = arts else {
                self?.contentStatus = .failed
                return
            }
            self?.contentStatus = .loaded(arts)
        }
    }
    
    private func loadCellImage(cell: ArtViewCell, art: Art) {
        cell.imageState = .loading
        cell.tag = art.objectID
        guard let imageURL =  art.primaryImage else {
            cell.imageState = .failed
            return
        }
        self.imageLoader.loadImage(urlString: imageURL) { image in
            guard cell.tag == art.objectID else { return }
            guard let image = image else {
                cell.imageState = .failed
                return
            }
            cell.imageState = .loaded(image)
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
    
    private func loadArtIDs(completion: @escaping([ArtID]?) -> Void) {
        guard let id = self.departmentId else {
            self.contentStatus = .failed
            completion(nil)
            return
        }
        self.metAPI.objects(departmentIds: [id]) { [weak self] objectResponse in
            guard let objectResponse = objectResponse else {
                self?.contentStatus = .failed
                completion(nil)
                return
            }
            completion(objectResponse.objectIDs)
        }
    }
    
    private func loadListOfArts(completion: @escaping([Art]?) -> Void) {
        self.loadArtIDs { [weak self] artIDs in
            guard let self = self,
                  let artIDs = artIDs else {
                completion(nil)
                return
            }
            let group = DispatchGroup()
            var arts: [Art] = []
            for artID in artIDs {
                group.enter()
                self.metAPI.object(id: artID, completion: { objectResponce in
                    guard let art = objectResponce else {
                        group.leave()
                        return
                    }
                    arts.append(art)
                    group.leave()
                })
            }
            group.notify(queue: .main) {
                completion(arts)
            }
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
            self.loadCellImage(cell: cell, art: art)
            cell.isLiked = self.isArtLiked(art: art)
            cell.text = String.artDescriptionText(art: art)
            if let departmentName = art.department {
                cell.tags = [departmentName]
            }
            cell.onLikeButtonDidTap = { [weak self] in
                self?.likeButtonDidTap(cell: cell, art: art)
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
}


