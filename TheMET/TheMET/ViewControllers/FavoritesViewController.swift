//
//  FavoritesViewController.swift
//  TheMET
//
//  Created by Анна Ситникова on 21/03/2023.
//

import Foundation
import UIKit

class FavoritesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let favoriteService = FavoritesService.standart
    
    private let imageLoader = ImageLoader()
    
    var tableView: UITableView = UITableView(frame: .zero, style: .plain)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.tabBarItem = UITabBarItem(title: nil,
                                       image: UIImage(named: "FavoriteIcon")?.withRenderingMode(.alwaysOriginal),
                                       selectedImage: UIImage(named: "FavoriteIconTapped")?.withRenderingMode(.alwaysOriginal))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.standardAppearance = self.navigationItem.apply(title: NSLocalizedString("favories_screen_title", comment: ""), color: UIColor(named: "plum"), fontName: NSLocalizedString("serif_font", comment: ""), fontSize: 22)
        NotificationCenter.default.addObserver(self, selector: #selector(favoriteServiceDidChange), name: FavoritesService.didChangeFavoriteArtsNotificationName, object: nil)
        self.tableView.backgroundColor = .clear
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.tableView)
        NSLayoutConstraint.activate([
            self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        self.tableView.separatorStyle = .none
        self.tableView.estimatedRowHeight = 10
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.register(ArtViewCell.self, forCellReuseIdentifier: ArtViewCell.artViewCellIdentifier)
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    @objc
    private func favoriteServiceDidChange() {
        self.tableView.reloadData()
    }
    
    private func loadCellImage(cell: ArtViewCell, indexPath: IndexPath) {
        cell.imageState = .loading
        guard let imageURL =  self.favoriteService.favoriteArts[indexPath.row].primaryImage else {
            cell.imageState = .failed
            return
        }
        self.imageLoader.loadImage(urlString: imageURL) { image in
            guard let image = image else {
                cell.imageState = .failed
                return
            }
            cell.imageState = .loaded(image)
        }
    }
    
    private func loadCellText(cell: ArtViewCell, indexPath: IndexPath) -> String {
        var cellText: String = ""
        if let artistDisplayName = self.favoriteService.favoriteArts[indexPath.row].artistDisplayName,
           artistDisplayName.isEmpty == false {
            cellText.append(artistDisplayName + "\n")
        }
        if let title = self.favoriteService.favoriteArts[indexPath.row].title,
           title.isEmpty == false {
            cellText.append(title + "\n")
        }
        if let objectDate = self.favoriteService.favoriteArts[indexPath.row].objectDate,
           objectDate.isEmpty == false {
            cellText.append(objectDate + "\n")
        }
        if let medium = self.favoriteService.favoriteArts[indexPath.row].medium,
           medium.isEmpty == false {
            cellText.append(medium + "\n")
        }
        return cellText
    }
    
    private func loadCellTags(cell: ArtViewCell, indexPath: IndexPath) -> [String] {
        var tags: [String] = []
        if let departmentName = self.favoriteService.favoriteArts[indexPath.row].department {
            tags.append(departmentName)
        }
        return tags
    }
    
    private func reloadFavoritesViewController() {
        
    }
    
//  UITableViewDelegate, UITableViewDataSource
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: ArtViewCell.artViewCellIdentifier, for: indexPath) as? ArtViewCell {
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            self.loadCellImage(cell: cell, indexPath: indexPath)
            cell.isLiked = true
            cell.text = self.loadCellText(cell: cell, indexPath: indexPath)
            cell.tags = self.loadCellTags(cell: cell, indexPath: indexPath)
            let oblectID = self.favoriteService.favoriteArts[indexPath.row].objectID
            cell.onLikeButtonDidTap = { [weak self] in
                self?.favoriteService.removeArt(id: oblectID)
            }
            return cell
        } else {
            print ("Error")
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.favoriteService.favoriteArts.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}


