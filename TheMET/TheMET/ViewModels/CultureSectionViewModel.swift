//
//  CultureSectionViewModel.swift
//  TheMET
//
//  Created by Анна Ситникова on 20/02/2024.
//

import Foundation
import Combine
import UIKit
import MetAPI

class CultureSectionViewModel {
    
    @Published private(set) var contentStatus:LoadingStatus<[CatalogSectionCellData<String>]>
    
    @Published private(set) var title: String
    
    private let presentingControllerProvider: () -> UIViewController?
    
    private let culturesService = CulturesService.standart
    
    private var cultureServiceSubscriber: AnyCancellable?
    
    private let metAPI = MetAPI()
    
    private var loadingCulturesNames: [String] = []
    
    private var loadedCultures: [CatalogSectionCellData<String>] = []
    
    init(presentingControllerProvider: @escaping () -> UIViewController?) {
        self.contentStatus = .loading
        self.title = NSLocalizedString("catalog_screen_cultures_section_title", comment: "")
        self.presentingControllerProvider = presentingControllerProvider
        self.cultureServiceSubscriber = self.culturesService.$culturesList
            .sink(receiveValue: { [weak self] newCulturesList in
                self?.reloadCatalog(culturesList: newCulturesList)
            })
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
    
    func reloadButtonDidTap() {
        self.reloadCatalog(culturesList: self.culturesService.culturesList)
    }
    
    func cultureCellDidTap(_ culture: String) {
        guard let presentingController = self.presentingControllerProvider() else {
            return
        }
        let cultureArtsViewController = CultureArtsViewController()
        cultureArtsViewController.culture = culture
        presentingController.navigationController?.pushViewController(cultureArtsViewController, animated: true)
    }
    
    func loadParticularCultureCellDataIfNeeded(culture: String) {
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
