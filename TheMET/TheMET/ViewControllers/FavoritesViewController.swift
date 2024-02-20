//
//  FavoritesViewController.swift
//  TheMET
//
//  Created by Анна Ситникова on 21/03/2023.
//

import Foundation
import UIKit
import Combine

class FavoritesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    private let artFilter : ArtFilter = ArtFilter()
    
    private var displayArts: [Art] = []
    
    private let searchBar: UISearchBar = UISearchBar()
    
    private let favoriteService = FavoritesService.standart
    
    private var favoriteServiseSubscriber: AnyCancellable?
    
    private let imageLoader = ImageLoader()

    private let failedSearchView = FailedPlaceholderView.constructView(configuration: .searchArtsFailed)
    
    private let transparentView = UIView()
    
    var tableView: UITableView = UITableView(frame: .zero, style: .plain)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.tabBarItem = UITabBarItem(title: nil,
                                       image: UIImage(named: "FavoriteIcon")?.withRenderingMode(.alwaysOriginal),
                                       selectedImage: UIImage(named: "FavoriteIconTapped")?.withRenderingMode(.alwaysOriginal))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.displayArts = self.favoriteService.favoriteArts
        self.navigationController?.navigationBar.standardAppearance = self.navigationItem.apply(title: NSLocalizedString("favories_screen_title", comment: ""), color: UIColor(named: "plum"), fontName: NSLocalizedString("serif_font", comment: ""), fontSize: 22)
        self.favoriteServiseSubscriber = self.favoriteService.$favoriteArts
            .sink(receiveValue: { [weak self] newFavoriteArts in
                self?.favoriteServiceDidChange(favoriteArts: newFavoriteArts)
            })
        self.searchBar.apply(barTintColor: UIColor(named: "blackberry"), textFieldBackgroundColor: UIColor(named: "blueberry0.5"), textFieldColor: UIColor(named: "plum"))
        self.searchBar.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.searchBar)
        self.tableView.backgroundColor = .clear
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.tableView)
        NSLayoutConstraint.activate([
            self.searchBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.searchBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.searchBar.topAnchor.constraint(equalTo: self.view.topAnchor)
        ])
        NSLayoutConstraint.activate([
            self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.tableView.topAnchor.constraint(equalTo: self.searchBar.bottomAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        self.add(subView: self.failedSearchView, topAnchorSubView: self.searchBar)
        self.failedSearchView.isHidden = true
        self.tableView.separatorStyle = .none
        self.tableView.estimatedRowHeight = 10
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.register(ArtViewCell.self, forCellReuseIdentifier: ArtViewCell.artViewCellIdentifier)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.searchBar.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: UIResponder.keyboardWillHideNotification, object: nil)
           NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
        self.setupHideKeyboardTapRegogniser()
    }
    
    @objc
    private func keyboardWillDisappear() {
        self.transparentView.removeFromSuperview()
    }
    
    @objc
    private func keyboardWillAppear() {
        self.transparentView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.transparentView)
        self.transparentView.backgroundColor = .clear
        NSLayoutConstraint.activate([
            self.transparentView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
            self.transparentView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
            self.transparentView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0),
            self.transparentView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0)
        ])
    }
   
    private func setupHideKeyboardTapRegogniser() {
        let tap: UIGestureRecognizer  = UITapGestureRecognizer(
            target: self,
            action: #selector(dissmissKeyboard)
        )
        self.transparentView.addGestureRecognizer(tap)
    }
    
    @objc
    private func dissmissKeyboard() {
        self.view.endEditing(true)
    }
    
    private func add(subView: UIView, topAnchorSubView: UIView) {
        subView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(subView)
        subView.backgroundColor = .clear
        let constraints: [NSLayoutConstraint] = [
            subView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
            subView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
            subView.topAnchor.constraint(equalTo: topAnchorSubView.bottomAnchor, constant: 0),
            subView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    private func favoriteServiceDidChange(favoriteArts: [Art]) {
        self.displayArts = self.artFilter.filter(arts: favoriteArts, searchText: self.searchBar.searchTextField.text)
        self.tableView.reloadData()
    }
    
    private func loadCellImage(cell: ArtViewCell, art: Art) {
        cell.imageState = .loading
        cell.tag = art.objectID
        guard let imageURL =  art.primaryImage else {
            cell.imageState = .failed(ArtImageLoadingError.invalidImageURL)
            return
        }
        self.imageLoader.loadImage(urlString: imageURL) { image in
            guard cell.tag == art.objectID else { return }
            guard let image = image else {
                cell.imageState = .failed(ArtImageLoadingError.imageCannotBeLoadedFromURL)
                return
            }
            cell.imageState = .loaded(image)
        }
    }
    
    private func loadCellTags(art: Art) -> [String] {
        var tags: [String] = []
        if let departmentName = art.department {
            tags.append(departmentName)
        }
        return tags
    }
    
    private func imageDidTap(image: UIImage) {
        let fullScreenViewController =  FullScreenPhotoViewController()
        fullScreenViewController.modalPresentationStyle = .fullScreen
        fullScreenViewController.image = image
        self.present(fullScreenViewController, animated: true)
    }
    
//  UITableViewDelegate, UITableViewDataSource
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: ArtViewCell.artViewCellIdentifier, for: indexPath) as? ArtViewCell {
            var art: Art
            art = self.displayArts[indexPath.row]
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            self.loadCellImage(cell: cell, art: art)
            cell.isLiked = true
            cell.artistNameText = String.artistNameText(art: art)
            cell.titleText = String.titleText(art: art)
            cell.dateText = String.dateText(art: art)
            cell.mediumText = String.mediumText(art: art)
            cell.tags = self.loadCellTags(art: art)
            let oblectID = art.objectID
            cell.onLikeButtonDidTap = { [weak self] in
                self?.favoriteService.removeArt(id: oblectID)
            }
            cell.onImageDidTap = { [weak self] image in
                self?.imageDidTap(image: image)
            }
            return cell
        } else {
            print ("Error")
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.displayArts.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
//    UISearchBarDelegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.failedSearchView.isHidden = true
        guard !searchText.isEmpty else {
            self.displayArts = favoriteService.favoriteArts
            self.tableView.reloadData()
            return
        }
        self.displayArts = self.artFilter.filter(arts: self.favoriteService.favoriteArts, searchText: searchText)
        guard !self.displayArts.isEmpty else {
            self.failedSearchView.isHidden = false
            self.tableView.reloadData()
            return
        }
        self.tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
    }
      
}


