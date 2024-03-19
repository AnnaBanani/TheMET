//
//  CategoryViewController.swift
//  TheMET
//
//  Created by Анна Ситникова on 06/07/2023.
//

import Foundation
import UIKit
import Combine
import MetAPI

class CategoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate  {
    
    private var viewModel: CategoryArtsViewModel?
    
    private var categoryArtStatesSubscriber:AnyCancellable?
    private var searchTextSubscriber: AnyCancellable?
    
    private let searchBar: UISearchBar = UISearchBar()
    
    var departmentId: Int?
    
    private var imageLoader: ImageLoader = ImageLoader()
    
    var contentStatus: LoadingStatus<[CategoryArtState]> = .loading
    
    private let loadingCategoryView = LoadingPlaceholderView.construstView(configuration: .categoryArtworksLoading)
    private let failedCategoryView = FailedPlaceholderView.constructView(configuration: .categoryFailed)
    
    private let categoryTableView: UITableView = UITableView(frame: .zero, style: .plain)
    
    private let transparentView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.standardAppearance = self.navigationItem.apply(title: NSLocalizedString("", comment: ""), color: UIColor(named: "plum"), fontName: NSLocalizedString("serif_font", comment: ""), fontSize: 22)
        self.searchBar.apply(barTintColor: UIColor(named: "blackberry"), textFieldBackgroundColor: UIColor(named: "blueberry0.5"), textFieldColor: UIColor(named: "plum"))
        self.searchBar.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.searchBar)
        NSLayoutConstraint.activate([
            self.searchBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.searchBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.searchBar.topAnchor.constraint(equalTo: self.view.topAnchor)
        ])
        self.add(subView: self.loadingCategoryView, topAnchorSubView: self.searchBar)
        self.add(subView: self.failedCategoryView, topAnchorSubView: self.searchBar)
        self.add(subView: self.categoryTableView, topAnchorSubView: self.searchBar)
        self.categoryTableView.separatorStyle = .none
        self.categoryTableView.estimatedRowHeight = 10
        self.categoryTableView.rowHeight = UITableView.automaticDimension
        self.categoryTableView.register(ArtViewCell.self, forCellReuseIdentifier: ArtViewCell.artViewCellIdentifier)
        self.categoryTableView.dataSource = self
        self.categoryTableView.delegate = self
        self.searchBar.delegate = self
        self.failedCategoryView.onButtonTap = { [weak self] in
            self?.viewModel?.reloadButtonDidTap()
        }
        self.updateContent()
        self.categoryTableView.reloadData()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
        self.setupHideKeyboardTapRegogniser()
        self.setUpViewModel()
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
    
    private func setUpViewModel() {
        let viewModel = CategoryArtsViewModel(presentingControllerProvider: { self }, departmentID: self.departmentId)
        self.viewModel = viewModel
        self.categoryArtStatesSubscriber = viewModel.$categoryArtStatesList
            .sink(receiveValue: { [weak self] newListState in
                guard let self = self else { return }
                self.contentStatus = newListState
                self.updateContent()
            })
        self.searchTextSubscriber = viewModel.$searchText
            .sink(receiveValue: { [weak self] newSearchText in
                guard let self = self else { return }
                self.searchBar.text = newSearchText
            })
        self.categoryTableView.reloadData()
    }
    
    private func updateContent() {
        switch contentStatus {
        case .failed(ArtsLoadingError.noSearchResult):
            self.loadingCategoryView.isHidden = true
            self.failedCategoryView.isHidden = false
            self.categoryTableView.isHidden = true
            self.failedCategoryView.set(configuration: .searchArtsFailed)
        case .failed:
            self.loadingCategoryView.isHidden = true
            self.failedCategoryView.isHidden = false
            self.categoryTableView.isHidden = true
            self.failedCategoryView.set(configuration: .categoryFailed)
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
    
    //  UITableViewDelegate, UITableViewDataSource
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: ArtViewCell.artViewCellIdentifier, for: indexPath) as? ArtViewCell {
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            guard case .loaded(let loadedData) = self.contentStatus else {
                return UITableViewCell()
            }
            let artState = loadedData[indexPath.row]
            switch artState {
            case .placeholder:
                cell.isPlaceholderVisible = true
            case .loaded(let loadedArtState):
                cell.isPlaceholderVisible = false
                self.viewModel?.artWillBeDisplayed(artState: loadedArtState)
                cell.isLiked = loadedArtState.isLiked
                cell.artistNameText = loadedArtState.artistsName
                cell.titleText = loadedArtState.titleText
                cell.dateText = loadedArtState.dateText
                cell.mediumText = loadedArtState.mediumText
                cell.imageState = loadedArtState.imageStatus
                cell.onLikeButtonDidTap = { [weak self] in
                    self?.viewModel?.likeButtonDidTap(artID: loadedArtState.objectID)
                }
                cell.onImageDidTap = { [weak self] image in
                    self?.viewModel?.imageDidTap(image: image)
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
        guard case .loaded(let categoryArtStates) = self.contentStatus else {
            return
        }
        let artState = categoryArtStates[forRowAt.row]
        self.viewModel?.artWillBeDisplayed(categoryArtState: artState)
    }
    
    //    UISearchBarDelegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.viewModel?.searchTextDidChange(searchText: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
    }
    
}


enum CategoryViewControllerError: Error {
    case departmentIdNotFound
}

