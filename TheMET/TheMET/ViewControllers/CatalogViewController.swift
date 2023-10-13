//
//  CatalogViewController.swift
//  TheMET
//
//  Created by Анна Ситникова on 21/03/2023.
//

import Foundation
import UIKit
import MetAPI


class CatalogViewController: UIViewController {
    
    private let metAPI = MetAPI()
    
    private let aboutButton: UIButton = UIButton()
    
    private let loadingCatalogView = LoadingPlaceholderView.construstView(configuration: .catalogLoading)
    private let failedCatalogView = FailedPlaceholderView.constructView(configuration: .catalogFailed)
    private let loadedCatalogView = CatalogContentView.constructView()
    
    private var loadedDepartments: [Department] = []
    
    var contentStatus:LoadingStatus<[CatalogCellData]> = .loading {
        didSet {
            self.updateContent()
        }
    }
    
    var loadingDepartmentIds: [Int] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.tabBarItem = UITabBarItem(title: nil,
                                       image: UIImage(named: "CatalogIcon")?.withRenderingMode(.alwaysOriginal),
                                       selectedImage: UIImage(named: "CatalogIconTapped")?.withRenderingMode(.alwaysOriginal))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.standardAppearance = self.navigationItem.apply(title: NSLocalizedString("catalog_screen_title", comment: ""), color: UIColor(named: "plum"), fontName: NSLocalizedString("serif_font", comment: ""), fontSize: 22)
        self.add(catalogSubview: self.failedCatalogView, stretchView: true)
        self.add(catalogSubview: self.loadedCatalogView, stretchView: false)
        self.add(catalogSubview: self.loadingCatalogView, stretchView: true)
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
        let aboutButton: UIBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "AboutAppIcon"),
            style: .plain,
            target: self,
            action: #selector(aboutButtonDidTap)
        )
        aboutButton.tintColor = UIColor(named: "plum")
        self.navigationItem.rightBarButtonItem = aboutButton
    }
    
    @objc
    private func aboutButtonDidTap() {
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let aboutAppViewController = mainStoryBoard.instantiateViewController(withIdentifier: "AboutAppViewController")
        aboutAppViewController.modalPresentationStyle = .automatic
        aboutAppViewController.modalTransitionStyle = .coverVertical
        let aboutAppNavigationController = UINavigationController(rootViewController: aboutAppViewController)
        self.present(aboutAppNavigationController, animated: true)
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
    
    private func add(catalogSubview: UIView, stretchView: Bool) {
        catalogSubview.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(catalogSubview)
        var constraints: [NSLayoutConstraint] = [
            catalogSubview.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
            catalogSubview.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
            catalogSubview.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0)
        ]
        
        if stretchView {
            constraints.append(catalogSubview.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0))
        }
        NSLayoutConstraint.activate(constraints)
    }
    
    private func reloadCatalog() {
        self.contentStatus = .loading
        self.metAPI.departments { [weak self] departmentResponseResult in
            switch departmentResponseResult {
            case .failure:
                self?.contentStatus = .failed
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
