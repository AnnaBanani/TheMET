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
    
    let loadingCatalogView = LoadingPlaceholderView.constructView(configuration: .catalogLoading)
    let failedCatalogView = LoadingPlaceholderView.constructView(configuration: .catalogFailed)
    let loadedCatalogView = CatalogContentView.constructView()
    
    enum Status {
        case loaded([CatalogCellData])
        case loading
        case failed
    }
    
    var contentStatus: Status = .loading {
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
        
        loadingCatalogView.translatesAutoresizingMaskIntoConstraints = false
        failedCatalogView.translatesAutoresizingMaskIntoConstraints = false
        loadedCatalogView.translatesAutoresizingMaskIntoConstraints = false
        self.updateContent()
        self.add(catalogSubview: failedCatalogView, stretchView: true)
        self.add(catalogSubview: loadedCatalogView, stretchView: false)
        self.add(catalogSubview: loadingCatalogView, stretchView: true)
        self.loadCatalogCellDataList { catalogCellDataList in
            guard let catalogCellDataList = catalogCellDataList else {
                self.contentStatus = .failed
                return
            }
            self.contentStatus = .loaded(catalogCellDataList)
        }
        self.updateContent()
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
        self.view.addSubview(catalogSubview)
        if stretchView {
            NSLayoutConstraint.activate([
                catalogSubview.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
                catalogSubview.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
                catalogSubview.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0),
                catalogSubview.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0)
            ])
        } else {
            NSLayoutConstraint.activate([
                catalogSubview.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
                catalogSubview.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
                catalogSubview.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0),
            ])
        }
    }
    
    private func loadCatalogCellDataList(completion: @escaping ([CatalogCellData]?) -> Void) {
        self.metAPI.departments { [weak self] departmentResponce in
            guard let responce = departmentResponce else {
                completion(nil)
                return
            }
            self?.loadCatalogCellDataList(departmens: responce.departments) { catalogCellDataList in
                completion(catalogCellDataList)
            }
        }
    }
    
    private func loadCatalogCellDataList(departmens: [Department], completion: @escaping ([CatalogCellData]) -> Void) {
        let group = DispatchGroup()
        var catalogCellDataList:[CatalogCellData] = []
        for department in departmens {
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
                let catalogCellData = CatalogCellData(catalogCellId: department.id, imageURL: nil, title: department.displayName, subTitle: nil)
                completion(catalogCellData)
                return
            }
            let subtitle: String = ("\(objects.total) objects")
//            localisation
            self?.loadDepartmentImageURL(objectIds: objects.objectIDs, completion: { url in
                let catalogCellData = CatalogCellData(catalogCellId: department.id, imageURL: url, title: department.displayName, subTitle: subtitle)
                completion(catalogCellData)
            })
        }
    }
    
    private func loadDepartmentImageURL(objectIds: [Int], completion: @escaping (URL?) -> Void) {
        guard !objectIds.isEmpty else {
            completion(nil)
            return
        }
        self.loadObjectImageURL(objectId: objectIds[0]) { [weak self] url in
            if let imageURL = url {
                completion(imageURL)
            } else {
                let newObjectsIds: [Int] = Array(objectIds.dropFirst())
                self?.loadDepartmentImageURL(objectIds: newObjectsIds, completion: completion)
            }
        }
    }

    private func loadObjectImageURL(objectId: Int, completion: @escaping (URL?) -> Void){
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
}

