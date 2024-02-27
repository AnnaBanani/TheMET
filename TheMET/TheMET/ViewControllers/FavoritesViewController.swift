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
    
    private var displayedState: LoadingStatus<[FavoriteArtState]> = .loading
    
    private var viewModel: FavoritesViewModel?
    
    private var titleSubscriber:AnyCancellable?
    private var artStatesSubscriber:AnyCancellable?
    private var searchtextSubscriber: AnyCancellable?
    
    private let searchBar: UISearchBar = UISearchBar()
    
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
        self.setupViewModel()
    }
    
    private func setupViewModel() {
        let viewModel = FavoritesViewModel(presentingControllerProvider: { [weak self] in
            return self
        })
        self.viewModel = viewModel
        self.titleSubscriber = viewModel.$title
            .sink(receiveValue: { [weak self] newTitle in
                guard let self = self else {return}
                self.navigationController?.navigationBar.standardAppearance = self.navigationItem.apply(title: newTitle, color: UIColor(named: "plum"), fontName: NSLocalizedString("serif_font", comment: ""), fontSize: 22)
        })
        self.artStatesSubscriber = viewModel.$artStates
            .sink(receiveValue: { [weak self] newArtStates in
                guard let self = self else {return}
                self.displayedState = newArtStates
                switch newArtStates {
                case .loaded:
                    self.failedSearchView.isHidden = true
                    self.tableView.isHidden = false
                    self.tableView.reloadData()
                case .loading:
                    break
                case .failed:
                    self.failedSearchView.isHidden = false
                    self.tableView.isHidden = true
                    break
                }
        })
        self.searchtextSubscriber = viewModel.$searchText
            .sink(receiveValue: { [weak self] newSearchText in
                guard let self = self else {return}
                self.tableView.reloadData()
        })
        
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
    
//    UITableViewDelegate, UITableViewDataSource
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: ArtViewCell.artViewCellIdentifier, for: indexPath) as? ArtViewCell {
            guard case .loaded(let loadedData) = self.displayedState else {
                return UITableViewCell()
            }
            let artState = loadedData[indexPath.row]
                cell.backgroundColor = .clear
                cell.selectionStyle = .none
                self.viewModel?.artWillBeDisplayed(art: artState)
                cell.imageState = artState.imageStatus
                cell.isLiked = true
                cell.artistNameText = artState.artistsName
                cell.titleText = artState.titleText
                cell.dateText = artState.dateText
                cell.mediumText = artState.mediumText
                let oblectID = artState.objectID
                cell.onLikeButtonDidTap = { [weak self] in
                    self?.viewModel?.onLikeButtonDidTap(id: oblectID)
                }
                cell.onImageDidTap = { [weak self] image in
                    self?.viewModel?.imageDidTap(image: image)
                }
                return cell
        } else {
            print ("Error")
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard case .loaded(let loadedData) = displayedState else {
            return 0
        }
        return loadedData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
//    UISearchBarDelegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.viewModel?.searchTextDidChange(searchText: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
    }
      
}


