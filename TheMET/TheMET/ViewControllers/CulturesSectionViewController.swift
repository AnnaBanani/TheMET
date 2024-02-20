//
//  CulturesSectionViewController.swift
//  TheMET
//
//  Created by Анна Ситникова on 12/12/2023.
//

import Foundation
import UIKit
import MetAPI
import Combine

class CulturesSectionViewController: UIViewController {
    
    private var viewModel: CultureSectionViewModel?
    
    private let culturesLabel: UILabel = UILabel()
    
    private var contentStatusSubscriber: AnyCancellable?
    private var titleSubscriber: AnyCancellable?
    
    private let loadingCulturesCatalogView = CatalogSectionLoadingView.constractView(configuration: .catalogSectionLoading)
    private let failedCulturesCatalogView = CatalogSectionTapToReloadView.constractView(configuration: .catalogSectionTapToReload)
    private let loadedCulturesCatalogView = CulturesSectionContentView.constructView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.culturesLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(culturesLabel)
        self.culturesLabel.textAlignment = .center
        NSLayoutConstraint.activate([
            self.culturesLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            self.culturesLabel.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            self.culturesLabel.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.culturesLabel.heightAnchor.constraint(equalToConstant: 60)
            ])
        self.add(catalogSubview: self.failedCulturesCatalogView)
        self.add(catalogSubview: self.loadedCulturesCatalogView)
        self.add(catalogSubview: self.loadingCulturesCatalogView)
        self.failedCulturesCatalogView.onButtonTap = { [weak self] in
            self?.viewModel?.reloadButtonDidTap()
        }
        self.loadedCulturesCatalogView.onCultureCellTap = { [weak self] culture in
            self?.viewModel?.cultureCellDidTap(culture)
        }
        self.loadedCulturesCatalogView.onCultureCellWillDisplay = { [weak self] culture in
            self?.viewModel?.loadParticularCultureCellDataIfNeeded(culture: culture)
        }
        self.setupViewModel()
    }
    
    private func setupViewModel() {
        let viewModel = CultureSectionViewModel(presentingControllerProvider: { [weak self] in
            return self
        })
        self.viewModel = viewModel
        self.titleSubscriber = viewModel.$title
            .sink(receiveValue: { [weak self] newTitle in
                guard let self = self else {return}
                self.culturesLabel.apply(font: NSLocalizedString("serif_font", comment: ""), color: UIColor(named: "pear"), fontSize: 16, title: newTitle)
        })
        self.contentStatusSubscriber = viewModel.$contentStatus
            .sink(receiveValue: { [weak self] newContentStaus in
                guard let self = self else {return}
                self.updateContent(contentStatus: newContentStaus)
        })
    }
    
    private func add(catalogSubview: UIView) {
        catalogSubview.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(catalogSubview)
        NSLayoutConstraint.activate([
            catalogSubview.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
            catalogSubview.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
            catalogSubview.topAnchor.constraint(equalTo: self.culturesLabel.bottomAnchor, constant: 0),
            catalogSubview.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
    private func updateContent(contentStatus: LoadingStatus<[CatalogSectionCellData<String>]>) {
        switch contentStatus {
        case .failed:
            self.loadedCulturesCatalogView.culturesContent = []
            self.loadingCulturesCatalogView.isHidden = true
            self.failedCulturesCatalogView.isHidden = false
            self.loadedCulturesCatalogView.isHidden = true
        case .loaded(let culturesCellDataList):
            self.loadedCulturesCatalogView.culturesContent = culturesCellDataList
            self.loadingCulturesCatalogView.isHidden = true
            self.failedCulturesCatalogView.isHidden = true
            self.loadedCulturesCatalogView.isHidden = false
        case .loading:
            self.loadedCulturesCatalogView.culturesContent = []
            self.loadingCulturesCatalogView.isHidden = false
            self.failedCulturesCatalogView.isHidden = true
            self.loadedCulturesCatalogView.isHidden = true
        }
    }
    
}
