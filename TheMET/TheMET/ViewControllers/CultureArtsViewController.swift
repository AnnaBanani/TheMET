//
//  CultureArtsViewController.swift
//  TheMET
//
//  Created by Анна Ситникова on 12/12/2023.
//

import Foundation
import UIKit
import Combine
import MetAPI

class CultureArtsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate  {
    
    private var viewModel: CultureArtsViewModel?
    
    private var cultureArtStatesSubscriber:AnyCancellable?
    private var searchTextSubscriber: AnyCancellable?
    
    private let searchBar: UISearchBar = UISearchBar()
    
    var culture: String?
    
    private let loadingCategoryView = LoadingPlaceholderView.construstView(configuration: .categoryArtworksLoading)
    private let failedCategoryView = FailedPlaceholderView.constructView(configuration: .categoryFailed)
    
    private let culturesTableView: UITableView = UITableView(frame: .zero, style: .plain)
    
    private let transparentView = UIView()
    
    var contentStatus: LoadingStatus<[CultureArtState]> = .loading
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.standardAppearance = self.navigationItem.apply(title: NSLocalizedString("", comment: ""), color: UIColor(named: "plum"), fontName: NSLocalizedString("serif_font", comment: ""), fontSize: 22)
        self.view.backgroundColor = UIColor(named: "blackberry")
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
        self.add(subView: self.culturesTableView, topAnchorSubView: self.searchBar)
        self.culturesTableView.separatorStyle = .none
        self.culturesTableView.estimatedRowHeight = 10
        self.culturesTableView.rowHeight = UITableView.automaticDimension
        self.culturesTableView.register(ArtViewCell.self, forCellReuseIdentifier: ArtViewCell.artViewCellIdentifier)
        self.culturesTableView.dataSource = self
        self.culturesTableView.delegate = self
        self.searchBar.delegate = self
        self.failedCategoryView.onButtonTap = { [weak self] in
            self?.viewModel?.reloadButtonDidTap()
        }
        self.updateContent()
        self.culturesTableView.reloadData()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
        self.setupHideKeyboardTapRegogniser()
        self.setUpViewModel()
    }
    
    private func setUpViewModel() {
        let viewModel = CultureArtsViewModel(culture: self.culture, presentingControllerProvider: { self })
        self.viewModel = viewModel
        self.cultureArtStatesSubscriber = viewModel.$cultureArtStatesList
            .sink(receiveValue: { [weak self] newListState in
                guard let self = self else { return }
                self.contentStatus = newListState
                self.updateContent()
            })
        self.searchTextSubscriber = viewModel.$searchText
            .sink(receiveValue: { [weak self] searchText in
                guard let self = self else { return }
                self.searchBar.text = searchText
            })
        self.culturesTableView.reloadData()
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
    
    private func updateContent() {
        switch contentStatus {
        case .failed(ArtsLoadingError.noSearchResult):
            self.loadingCategoryView.isHidden = true
            self.failedCategoryView.isHidden = false
            self.culturesTableView.isHidden = true
            self.failedCategoryView.set(configuration: .searchArtsFailed)
        case .failed:
            self.loadingCategoryView.isHidden = true
            self.failedCategoryView.isHidden = false
            self.culturesTableView.isHidden = true
            self.failedCategoryView.set(configuration: .categoryFailed)
        case .loaded:
            self.loadingCategoryView.isHidden = true
            self.failedCategoryView.isHidden = true
            self.culturesTableView.isHidden = false
        case .loading:
            self.loadingCategoryView.isHidden = false
            self.failedCategoryView.isHidden = true
            self.culturesTableView.isHidden = true
        }
        self.culturesTableView.reloadData()
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
    
    // UITableViewDelegate, UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch self.contentStatus {
        case .failed, .loading:
            return 0
        case .loaded(let arts):
            return arts.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: ArtViewCell.artViewCellIdentifier, for: indexPath) as? ArtViewCell {
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            guard case .loaded(let loadedData) = self.contentStatus else {
                return UITableViewCell()
            }
            let artState = loadedData[indexPath.row]
            switch artState {
            case .placeholder(let artID):
                cell.tag = artID
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay: UITableViewCell, forRowAt: IndexPath) {
        guard case .loaded(let cultureArtStates) = self.contentStatus else {
            return
        }
        let artState = cultureArtStates[forRowAt.row]
        self.viewModel?.artWillBeDisplayed(cultureArtState: artState)
    }
    
    //    UISearchBarDelegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.viewModel?.searchTextDidChange(searchText: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
    }
}

enum CultureArtsLoadingError: Error {
    case cultureNameNotFound
}

