//
//  DepartmentsSectionViewModel.swift
//  TheMET
//
//  Created by Анна Ситникова on 25/01/2024.
//

import Foundation
import Combine
import UIKit
import MetAPI

class DepartmentsSectionViewModel {
    
    private let metAPI = MetAPI()
    
    @Published private(set) var title: String
    
    @Published private(set) var contentStatus: LoadingStatus<[CatalogSectionCellData<Int>]>
    
    private let presentingControllerProvider: () -> UIViewController?
    
    private var loadedDepartments: [Department] = []
    
    private var loadingDepartmentIds: [Int] = []
    
    init(presentingControllerProvider: @escaping () -> UIViewController?) {
        self.title = NSLocalizedString("catalog_screen_departments_section_title", comment: "")
        self.contentStatus = .loading
        self.presentingControllerProvider = presentingControllerProvider
        self.reloadCatalog()
    }
    
    func cellDidTap(departmentId: Int) {
        guard let presentingController = self.presentingControllerProvider() else {
            return
        }
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let categoryViewController = mainStoryBoard.instantiateViewController(withIdentifier: "CategoryViewController") as? CategoryViewController
        guard let categoryViewController = categoryViewController else { return }
        categoryViewController.departmentId = departmentId
        presentingController.navigationController?.pushViewController(categoryViewController, animated: true)
    }
    
    private func cellAppeared(objectIds: [ArtID], completion: @escaping (URL?) -> Void) {
        guard !objectIds.isEmpty else {
            completion(nil)
            return
        }
        self.loadObjectImageURL(objectId: objectIds[0]) { [weak self] url in
            if let imageURL = url {
                completion(imageURL)
            } else {
                let newObjectsIds: [ArtID] = Array(objectIds.dropFirst())
                self?.cellAppeared(objectIds: newObjectsIds, completion: completion)
            }
        }
    }
    
    func cellWillDisplay(departmentId: Int) {
        guard case .loaded(let catalogCellDataList) = self.contentStatus else {
            return
        }
        guard let catalogCellData = catalogCellDataList.first(where: { cellData in
            cellData.identificator == departmentId
        }),
              case .placeholder = catalogCellData.data,
              !self.loadingDepartmentIds.contains(departmentId),
              let department = self.loadedDepartments.first(where: { department in
                  department.id == departmentId
              })
        else {
            return
        }
        self.loadingDepartmentIds.append(departmentId)
        self.loadCatalogCellData(department: department, completion: { [weak self] catalogCellData in
            if let contentStatus = self?.contentStatus,
               case .loaded(var catalogCellDataList) = contentStatus,
               let catalogCellDataIndex = catalogCellDataList.firstIndex(where: { $0.identificator == catalogCellData.identificator}) {
                catalogCellDataList[catalogCellDataIndex] = catalogCellData
                self?.contentStatus = .loaded(catalogCellDataList)
            }
            self?.loadingDepartmentIds.removeAll { id in
                return id == departmentId
            }
        })
    }
    
    private func loadCatalogCellData(department: Department, completion: @escaping (CatalogSectionCellData<Int>) -> Void) {
        self.metAPI.objects(departmentIds: [department.id]) { [weak self] objectsResult in
            guard let self = self else {
                return
            }
            switch objectsResult {
            case .failure:
                let catalogCellData = CatalogSectionCellData(identificator: department.id, data: .data(imageURL: nil, title: department.displayName, subTitle: nil))
                completion(catalogCellData)
            case .success(let objects):
                let subtitle: String = self.cellSubtitle(objectsCount: objects.total)
                self.loadDepartmentImageURL(objectIds: objects.objectIDs, completion: { url in
                    let catalogCellData = CatalogSectionCellData(identificator: department.id, data: .data(imageURL: url, title: department.displayName, subTitle: subtitle))
                    completion(catalogCellData)
                })
            }
        }
    }
    
    private func cellSubtitle(objectsCount: ArtID) -> String {
        let formatString: String = NSLocalizedString("objects count", comment: "")
        return String.localizedStringWithFormat(formatString, objectsCount)
    }
    
    private func loadDepartmentImageURL(objectIds: [ArtID], completion: @escaping (URL?) -> Void) {
        guard !objectIds.isEmpty else {
            completion(nil)
            return
        }
        self.loadObjectImageURL(objectId: objectIds[0]) { [weak self] url in
            if let imageURL = url {
                completion(imageURL)
            } else {
                let newObjectsIds: [ArtID] = Array(objectIds.dropFirst())
                self?.loadDepartmentImageURL(objectIds: newObjectsIds, completion: completion)
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
    
    private func reloadCatalog() {
        self.contentStatus = .loading
        self.metAPI.departments { [weak self] departmentResponseResult in
            switch departmentResponseResult {
            case .failure(let error):
                self?.contentStatus = .failed(error)
            case .success(let departmentResponse):
                var catalogCellDataList: [CatalogSectionCellData<Int>] = []
                for department in departmentResponse.departments {
                    let catalogCellData: CatalogSectionCellData = CatalogSectionCellData(identificator: department.id, data: .placeholder)
                    catalogCellDataList.append(catalogCellData)
                }
                self?.loadedDepartments = departmentResponse.departments
                self?.contentStatus = .loaded(catalogCellDataList)
            }
        }
    }
    
    func reloadButtonDidTap() {
        self.reloadCatalog()
    }
}
