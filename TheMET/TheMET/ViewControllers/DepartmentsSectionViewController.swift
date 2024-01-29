//
//  DepartmentsSectionViewController.swift
//  TheMET
//
//  Created by Анна Ситникова on 08/11/2023.
//

import Foundation
import UIKit
import Combine

class DepartmentsSectionViewController: UIViewController {
    
    private var viewModel: DepartmentsSectionViewModel?
    
    private var contentStatusSubscriber: AnyCancellable?
    private var titleSubscriber: AnyCancellable?
    
    private let departmentLabel: UILabel = UILabel()
    
    private let loadingCatalogView = CatalogSectionLoadingView.constractView(configuration: .catalogSectionLoading)
    private let failedCatalogView = CatalogSectionTapToReloadView.constractView(configuration: .catalogSectionTapToReload)
    private let loadedCatalogView = DepartmentsSectionContentView.constructView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.departmentLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(departmentLabel)
        self.departmentLabel.textAlignment = .center
        NSLayoutConstraint.activate([
            self.departmentLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            self.departmentLabel.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            self.departmentLabel.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.departmentLabel.heightAnchor.constraint(equalToConstant: 60)
        ])
        self.add(catalogSubview: self.failedCatalogView)
        self.add(catalogSubview: self.loadedCatalogView)
        self.add(catalogSubview: self.loadingCatalogView)
        self.failedCatalogView.onButtonTap = { [weak self] in
            self?.viewModel?.reloadButtonDidTap()
        }
        self.loadedCatalogView.onCatalogCellTap = { [weak self] departmentId in
            self?.viewModel?.cellDidTap(departmentId: departmentId)
        }
        self.loadedCatalogView.onCatalogCellWillDisplay = { [weak self] departmentId in
            self?.viewModel?.cellWillDisplay(departmentId: departmentId)
        }
        self.setupViewModel()
    }
    
    private func setupViewModel() {
        let viewModel = DepartmentsSectionViewModel(presentingControllerProvider: { [weak self] in
            return self
        })
        self.viewModel = viewModel
        self.titleSubscriber = viewModel.$title
            .sink(receiveValue: { [weak self] titleText in
                guard let self = self else {return}
                self.departmentLabel.apply(font: NSLocalizedString("serif_font", comment: ""), color: UIColor(named: "pear"), fontSize: 16, title: titleText)
            })
        self.contentStatusSubscriber = viewModel.$contentStatus
            .sink(receiveValue: { [weak self] contentStatus in
                guard let self = self else {return}
                self.updateContent(contentStatus: contentStatus)
            })
    }
    
    private func updateContent(contentStatus: LoadingStatus<[CatalogSectionCellData<Int>]>) {
        switch contentStatus {
        case .failed:
            self.loadedCatalogView.content = []
            self.loadingCatalogView.isHidden = true
            self.failedCatalogView.isHidden = false
            self.loadedCatalogView.isHidden = true
        case .loaded(let catalogCellDataList):
            self.loadedCatalogView.content = catalogCellDataList
            self.loadingCatalogView.isHidden = true
            self.failedCatalogView.isHidden = true
            self.loadedCatalogView.isHidden = false
        case .loading:
            self.loadedCatalogView.content = []
            self.loadingCatalogView.isHidden = false
            self.failedCatalogView.isHidden = true
            self.loadedCatalogView.isHidden = true
        }
    }
    
    private func add(catalogSubview: UIView) {
        catalogSubview.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(catalogSubview)
        NSLayoutConstraint.activate([
            catalogSubview.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
            catalogSubview.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
            catalogSubview.topAnchor.constraint(equalTo: self.departmentLabel.bottomAnchor, constant: 0),
            catalogSubview.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
//    private func reloadCatalog() {
//        let viewModel = DepartmentsSectionViewModel(presentingControllerProvider: { [weak self] in
//            return self
//        })
//        self.viewModel = viewModel
//        viewModel.reloadCatalog()
//    }
    
    private func catalogCellDidTap(_ departmentId: Int) {
        self.viewModel?.cellDidTap(departmentId: departmentId)
    }
    
}
