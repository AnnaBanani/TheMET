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
    
    private let culturesService = CulturesService.standart
    
    private var cultureServiceSubscriber: AnyCancellable?
    
    private let metAPI = MetAPI()
    
    private let culturesLabel: UILabel = UILabel()
    
    private var loadingCulturesNames: [String] = []
    
    private let loadingCulturesCatalogView = CatalogSectionLoadingView.constractView(configuration: .catalogSectionLoading)
    private let failedCulturesCatalogView = CatalogSectionTapToReloadView.constractView(configuration: .catalogSectionTapToReload)
    private let loadedCulturesCatalogView = CulturesSectionContentView.constructView()
    
    private var loadedCultures: [CatalogSectionCellData<String>] = []
    
    var contentStatus:LoadingStatus<[CatalogSectionCellData<String>]> = .loading {
        didSet {
            self.updateContent()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.culturesLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(culturesLabel)
        self.culturesLabel.apply(font: NSLocalizedString("serif_font", comment: ""), color: UIColor(named: "pear"), fontSize: 16, title: NSLocalizedString("catalog_screen_cultures_section_title", comment: ""))
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
            self?.reloadButtonDidTap()
        }
        self.loadedCulturesCatalogView.onCultureCellTap = { [weak self] culture in
            self?.cultureCellDidTap(culture)
        }
        self.loadedCulturesCatalogView.onCultureCellWillDisplay = { [weak self] culture in
            self?.loadParticularCultureCellDataIfNeeded(culture: culture)
        }
        self.cultureServiceSubscriber = self.culturesService.$culturesList
            .sink(receiveValue: { [weak self] newCulturesList in
                self?.reloadCatalog(culturesList: newCulturesList)
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
    
    private func updateContent() {
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
    
    private func reloadButtonDidTap() {
        self.reloadCatalog(culturesList: self.culturesService.culturesList)
    }
    
    private func reloadCatalog(culturesList: [String]) {
        self.contentStatus = .loading
        var culturesCellDataList: [CatalogSectionCellData<String>] = []
        for culture in culturesList {
            let cultureCellData: CatalogSectionCellData = CatalogSectionCellData(identificator: culture, data: .placeholder)
            culturesCellDataList.append(cultureCellData)
        }
        self.loadedCultures = culturesCellDataList
        self.contentStatus = .loaded(culturesCellDataList)
    }
    
    private func cultureCellDidTap(_ culture: String) {
        let cultureArtsViewController = CultureArtsViewController()
        cultureArtsViewController.culture = culture
        self.navigationController?.pushViewController(cultureArtsViewController, animated: true)
    }
    
    
    private func loadParticularCultureCellDataIfNeeded(culture: String) {
        guard case .loaded(let cultureCellDataList) = self.contentStatus else {
            return
        }
        guard let cultureCellData = cultureCellDataList.first(where: { cellData in
            cellData.identificator == culture
        }),
              case .placeholder = cultureCellData.data,
              !self.loadingCulturesNames.contains(culture),
              let particularCulture = self.loadedCultures.first(where: { particularCulture in
                  particularCulture.identificator == culture
              })
        else { return }
        self.loadingCulturesNames.append(particularCulture.identificator)
        self.loadCultureCellData(culture: culture, completion: { [weak self] cultureCellData in
            guard let self = self else { return }
            if case .loaded(var culturesCellDataList) = self.contentStatus,
               let cultureCellDataIndex = culturesCellDataList.firstIndex(where: { $0.identificator == cultureCellData.identificator}) {
                culturesCellDataList[cultureCellDataIndex] = cultureCellData
                self.contentStatus = .loaded(culturesCellDataList)
            }
            self.loadingCulturesNames.removeAll { name in
                return name == culture
            }
        })
    }
    
    private func loadCultureCellData(culture: String, attempt: Int = 0, completion: @escaping (CatalogSectionCellData<String>) -> Void) {
        let parameters:[SearchParameter] = [
            .artistOrCulture(true),
            .q(culture)
        ]
        self.metAPI.search(parameters: parameters) { [weak self] searchResults in
            guard let self = self else {
                return
            }
            switch searchResults {
            case .failure(let error):
                guard case .nonDecodableData = error,
                      attempt > 5 else {
                    self.loadCultureCellData(culture: culture, attempt: attempt + 1, completion: completion)
                    return
                }
                let cultureCellData = CatalogSectionCellData(identificator: culture, data: .data(imageURL: nil, title: culture, subTitle: nil))
                completion(cultureCellData)
            case .success(let objects):
                let subtitle: String = self.cellSubtitle(objectsCount: objects.total)
                self.loadCultureImageURL(objectsIDs: objects.objectIDs) { url in
                    let cultureCellData = CatalogSectionCellData(identificator: culture, data: .data(imageURL: url, title: culture, subTitle: subtitle))
                    completion(cultureCellData)
                }
            }
        }
    }
    
    private func cellSubtitle(objectsCount: ArtID) -> String {
        let formatString: String = NSLocalizedString("objects count", comment: "")
        return String.localizedStringWithFormat(formatString, objectsCount)
    }
    
    private func loadCultureImageURL(objectsIDs: [ArtID], completion: @escaping (URL?) -> Void) {
        guard !objectsIDs.isEmpty else {
            completion(nil)
            return
        }
        self.loadObjectImageURL(objectId: objectsIDs[0]) { [weak self] url in
            if let imageURL = url {
                completion(imageURL)
            } else {
                let newObjectsIds: [ArtID] = Array(objectsIDs.dropFirst())
                self?.loadCultureImageURL(objectsIDs: newObjectsIds, completion: completion)
            }
        }
    }
    
    private func loadObjectImageURL(objectId: ArtID, completion: @escaping (URL?) -> Void){
        self.metAPI.object(id: objectId) { objectResult in
            switch objectResult {
            case .failure:
                completion(nil)
            case .success(let object):
                guard let imageURLstring = object.primaryImage else {
                    completion(nil)
                    return
                }
                completion(URL(string: imageURLstring))
            }
        }
    }
    
}
