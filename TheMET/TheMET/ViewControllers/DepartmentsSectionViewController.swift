//
//  DepartmentsSectionViewController.swift
//  TheMET
//
//  Created by Анна Ситникова on 08/11/2023.
//

import Foundation
import UIKit
import MetAPI

class DepartmentsSectionViewController: UIViewController {
    
    private let metAPI = MetAPI()
    
    private let departmentLabel: UILabel = UILabel()
    
    private let loadingCatalogView = CatalogSectionLoadingView.constractView(configuration: .catalogSectionLoading)
    private let failedCatalogView = CatalogSectionTapToReloadView.constractView(configuration: .catalogSectionTapToReload)
    private let loadedCatalogView = DepartmentsSectionContentView.constructView()
    
    private var loadedDepartments: [Department] = []
    
    var contentStatus:LoadingStatus<[CatalogCellData]> = .loading {
        didSet {
            self.updateContent()
        }
    }
    
    var loadingDepartmentIds: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.departmentLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(departmentLabel)
        self.departmentLabel.apply(font: NSLocalizedString("serif_font", comment: ""), color: UIColor(named: "pear"), fontSize: 16, title: NSLocalizedString("catalog_screen_departments_section_title", comment: ""))
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
            self?.reloadButtonDidTap()
        }
        self.loadedCatalogView.onCatalogCellTap = { [weak self] departmentId in
            self?.catalogCellDidTap(departmentId)
        }
        self.loadedCatalogView.onCatalogCellWillDisplay = { [weak self] departmentId in
            self?.loadParticularDepartmentCellDataIfNeeded(departmentId: departmentId)
        }
        self.reloadCatalog()
    }
    
    private func loadParticularDepartmentCellDataIfNeeded(departmentId: Int) {
        guard case .loaded(let catalogCellDataList) = self.contentStatus else {
            return
        }
        guard let catalogCellData = catalogCellDataList.first(where: { cellData in
            cellData.departmentId == departmentId
        }),
              case .placeholder = catalogCellData.departmentData,
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
               let catalogCellDataIndex = catalogCellDataList.firstIndex(where: { $0.departmentId == catalogCellData.departmentId}) {
                catalogCellDataList[catalogCellDataIndex] = catalogCellData
                self?.contentStatus = .loaded(catalogCellDataList)
            }
            self?.loadingDepartmentIds.removeAll { id in
                return id == departmentId
            }
        })
    }
    
    private func updateContent() {
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
    
    private func reloadCatalog() {
        self.contentStatus = .loading
        self.metAPI.departments { [weak self] departmentResponseResult in
            switch departmentResponseResult {
            case .failure(let error):
                self?.contentStatus = .failed(error)
            case .success(let departmentResponse):
                var catalogCellDataList: [CatalogCellData] = []
                for department in departmentResponse.departments {
                    let catalogCellData: CatalogCellData = CatalogCellData(departmentId: department.id, departmentData: .placeholder)
                    catalogCellDataList.append(catalogCellData)
                }
                self?.loadedDepartments = departmentResponse.departments
                self?.contentStatus = .loaded(catalogCellDataList)
            }
        }
    }
    
    private func loadCatalogCellData(department: Department, completion: @escaping (CatalogCellData) -> Void) {
        self.metAPI.objects(departmentIds: [department.id]) { [weak self] objectsResult in
            guard let self = self else {
                return
            }
            switch objectsResult {
            case .failure:
                let catalogCellData = CatalogCellData(departmentId: department.id, departmentData: .data(imageURL: nil, title: department.displayName, subTitle: nil))
                completion(catalogCellData)
            case .success(let objects):
                let subtitle: String = self.cellSubtitle(objectsCount: objects.total)
                self.loadDepartmentImageURL(objectIds: objects.objectIDs, completion: { url in
                    let catalogCellData = CatalogCellData(departmentId: department.id, departmentData: .data(imageURL: url, title: department.displayName, subTitle: subtitle))
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
    
    private func reloadButtonDidTap() {
        self.reloadCatalog()
    }
    
    private func catalogCellDidTap(_ departmentId: Int) {
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let categoryViewController = mainStoryBoard.instantiateViewController(withIdentifier: "CategoryViewController") as? CategoryViewController
        guard let categoryViewController = categoryViewController else { return }
        categoryViewController.departmentId = departmentId
        self.navigationController?.pushViewController(categoryViewController, animated: true)
    }
    
}
