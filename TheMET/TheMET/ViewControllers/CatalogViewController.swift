//
//  CatalogViewController.swift
//  TheMET
//
//  Created by Анна Ситникова on 21/03/2023.
//

import Foundation
import UIKit


class CatalogViewController: UIViewController {
    
    private let metAPI = MetAPI(networkManager: NetworkManager.standard)
    
    private let loadingCatalogView = LoadingPlaceholderView.constructView(configuration: .catalogLoading)
    private let failedCatalogView = LoadingPlaceholderView.constructView(configuration: .catalogFailed)
    private let loadedCatalogView = CatalogContentView.constructView()
    
    var contentStatus:LoadingStatus<[CatalogCellData]> = .loading {
        didSet {
            self.updateContent()
        }
    }
    
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
        self.reloadCatalog()
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
   
    private func loadCatalogCellDataList(completion: @escaping ([CatalogCellData]?) -> Void) {
        self.metAPI.departments { [weak self] departmentResponce in
            guard let responce = departmentResponce else {
                completion(nil)
                return
            }
            self?.loadCatalogCellDataList(departments: responce.departments) { catalogCellDataList in
                completion(catalogCellDataList)
            }
        }
    }
    
    private func loadCatalogCellDataList(departments: [Department], completion: @escaping ([CatalogCellData]) -> Void) {
        let group = DispatchGroup()
        var catalogCellDataList:[CatalogCellData] = []
        for department in departments {
            group.enter()
            self.loadCatalogCellData(department: department, completion: { cellData in
                catalogCellDataList.append(cellData)
                group.leave()
            })
        }
        group.notify(queue: .main) {
            completion(catalogCellDataList)
        }
    }
    
    private func loadCatalogCellData(department: Department, completion: @escaping (CatalogCellData) -> Void) {
        self.metAPI.objects(departmentIds: [department.id]) { [weak self] objects in
            guard let objects = objects else {
                let catalogCellData = CatalogCellData(departmentId: department.id, imageURL: nil, title: department.displayName, subTitle: nil)
                completion(catalogCellData)
                return
            }
            guard let self = self else {
                return
            }
            let subtitle: String = self.cellSubtitle(objectsCount: objects.total)
            self.loadDepartmentImageURL(objectIds: objects.objectIDs, completion: { url in
                let catalogCellData = CatalogCellData(departmentId: department.id, imageURL: url, title: department.displayName, subTitle: subtitle)
                completion(catalogCellData)
            })
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
        self.metAPI.object(id: objectId) { object in
            guard let object = object else {
                completion(nil)
                return
            }
            guard let imageURLstring = object.primaryImage else {
                completion(nil)
                return
            }
            completion(URL(string: imageURLstring))
        }
    }
    
    private func reloadButtonDidTap() {
        self.reloadCatalog()
    }
    
    private func reloadCatalog() {
        self.contentStatus = .loading
        self.loadCatalogCellDataList { [self] catalogCellDataList in
            guard let catalogCellDataList = catalogCellDataList else {
                self.contentStatus = .failed
                return
            }
            self.contentStatus = .loaded(catalogCellDataList)
        }
    }

    private func catalogCellDidTap(_ departmentId: Int) {
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let categoryViewController = mainStoryBoard.instantiateViewController(withIdentifier: "CategoryViewController") as? CategoryViewController
        guard let categoryViewController = categoryViewController else { return }
        categoryViewController.departmentId = departmentId
        self.navigationController?.pushViewController(categoryViewController, animated: true)
    }
    
}
