//
//  CategoryViewController.swift
//  TheMET
//
//  Created by Анна Ситникова on 06/07/2023.
//

import Foundation
import UIKit

class CategoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    private let favoriteService = FavoritesService.standart
    
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
        self.contentStatus = .loaded([])
    }
    
    
    //  UITableViewDelegate, UITableViewDataSource
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: ArtViewCell.artViewCellIdentifier, for: indexPath) as? ArtViewCell {
            if indexPath.row == 0 {
                cell.backgroundColor = .clear
                cell.selectionStyle = .none
                cell.imageState = .loaded(UIImage(named: "Image1")!)
                cell.isLiked = true
                cell.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam"
                cell.onLikeButtonDidTap = {
                    print("Test art with id 0 favourite button tapped")
                }
                cell.tags = ["aaaaaaa", "bbbbbbb", "ccccccc", "dddddddd", "eeeeeeeee"]
            } else if indexPath.row == 1 {
                cell.backgroundColor = .clear
                cell.selectionStyle = .none
                cell.imageState = .loaded(UIImage(named: "Image2")!)
                cell.isLiked = true
                cell.text = "quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum "
                cell.onLikeButtonDidTap = {
                    print("Test art with id 1 favourite button tapped")
                }
                cell.tags = ["aaaaaaa", "bbbbbbb", "ccccccc", "dddddddd", "eeeeeeeee"]
            } else {
                cell.backgroundColor = .clear
                cell.selectionStyle = .none
                cell.imageState = .loaded(UIImage(named: "Not Loaded Image")!)
                cell.isLiked = true
                cell.text = "quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum "
                cell.onLikeButtonDidTap = {
                    print("Test art with id 2 favourite button tapped")
                }
                cell.tags = ["aaaaaaa", "bbbbbbb", "ccccccc", "dddddddd", "eeeeeeeee"]
            }
            return cell
        } else {
            print ("Error")
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}


