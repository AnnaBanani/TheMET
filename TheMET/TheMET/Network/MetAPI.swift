//
//  MetAPI.swift
//  TheMET
//
//  Created by Анна Ситникова on 25/04/2023.
//

import Foundation

class MetAPI{
    
    private var networkManager: NetworkManager
    
    private let metAPICache = MetAPICashe.standard
    
    private let urlBaseString: String = "https://collectionapi.metmuseum.org/"
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    func objects(metadataDate: Date? = nil, departmentIds: [Int] = [], completion: @escaping (Result<ObjectsResponse, MetAPIError>) -> Void) {
        self.metAPICache.objects(metadataDate: metadataDate, departmentIds: departmentIds) { [weak self] objectsResponce in
            guard let self = self else {
                completion(.failure(.metAPIdoesNotAnswer))
                return
            }
            if let objectsResponce = objectsResponce {
                completion(.success(objectsResponce))
            } else {
                self.executeObjects(metadataDate: metadataDate, departmentIds: departmentIds) {[weak self] realResponse in
                    guard let realResponse = realResponse else {
                        completion(.failure(.noDataInResponce))
                        return
                    }
                    self?.metAPICache.putObjectsResponce(metadataDate: metadataDate, departmentIds: departmentIds, responceData: realResponse)
                    completion(.success(realResponse))
                }
            }
        }
    }
    
    private func executeObjects(metadataDate: Date?, departmentIds: [Int], completion: @escaping (ObjectsResponse?) -> Void) {
        var urlString: String = self.urlBaseString
        let urlStringSuffix: String = "public/collection/v1/objects"
        urlString.append(urlStringSuffix)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        var parameters: [String : String] = [ : ]
        let dateString: String?
        if let date = metadataDate {
            dateString = dateFormatter.string(from: date)
            parameters["metadataDate"] = dateString
        }
        let idArrayString: String
        if !departmentIds.isEmpty {
            idArrayString = departmentIds.map {String($0)}.joined(separator: "|")
            parameters["departmentIds"] = idArrayString
        }
        self.networkManager.get(
            urlString: urlString,
            parameters: parameters) { result in
                switch result {
                case .failure:
                    completion(nil)
                case .success(let data):
                    let jsonDecoder = JSONDecoder()
                    jsonDecoder.keyDecodingStrategy = .useDefaultKeys
                    do {
                        let result = try jsonDecoder.decode(ObjectsResponse.self, from: data)
                        completion(result)
                    } catch {
                        completion(nil)
                    }
                }
            }
    }
    
    func object(id: ArtID, completion: @escaping (Result<ObjectResponse, MetAPIError>) -> Void) {
        self.metAPICache.object(id: id) { [weak self] objectResponce in
            guard let self = self else {
                completion(.failure(.metAPIdoesNotAnswer))
                return
            }
            if let objectResponce = objectResponce {
                completion(.success(objectResponce))
            } else {
                self.executeObject(id: id) {[weak self] realResponse in
                    guard let realResponse = realResponse else {
                        completion(.failure(.noDataInResponce))
                        return
                    }
                    self?.metAPICache.putObjectResponce(id: id, responceData: realResponse)
                    completion(.success(realResponse))
                }
            }
        }
    }
    
    private func executeObject(id: ArtID, completion: @escaping (ObjectResponse?) -> Void) {
        var urlString: String = self.urlBaseString
        let urlStringSuffix: String = "public/collection/v1/objects/\(id)"
        urlString.append(urlStringSuffix)
        self.networkManager.get(
            urlString: urlString,
            parameters: [ : ]) { result in
                switch result {
                case .failure:
                    completion(nil)
                case .success(let data):
                    let jsonDecoder = JSONDecoder()
                    jsonDecoder.keyDecodingStrategy = .useDefaultKeys
                    do {
                        let result = try jsonDecoder.decode(ObjectResponse.self, from: data)
                        completion(result)
                    } catch {
                        completion(nil)
                    }
                }
            }
    }

    func departments(completion: @escaping (Result<DepartmentsResponse, MetAPIError>) -> Void) {
        self.metAPICache.departments { [weak self] departmentsResponce in
            guard let self = self else {
                completion(.failure(.metAPIdoesNotAnswer))
                return
            }
            if let departmentsResponce = departmentsResponce {
                completion(.success(departmentsResponce))
            } else {
                self.executeDepartments {[weak self] realResponse in
                    guard let realResponse = realResponse else {
                        completion(.failure(.noDataInResponce))
                        return
                    }
                    self?.metAPICache.putDepartmentsResponce(responceData: realResponse)
                    completion(.success(realResponse))
                }
            }
        }
    }
    
    func executeDepartments(completion: @escaping (DepartmentsResponse?) -> Void) {
        var urlString: String = self.urlBaseString
        let urlStringSuffix: String = "public/collection/v1/departments"
        urlString.append(urlStringSuffix)
        self.networkManager.get(
            urlString: urlString,
            parameters: [ : ]) { result in
                switch result {
                case .failure:
                    completion(nil)
                case .success(let data):
                    let jsonDecoder = JSONDecoder()
                    jsonDecoder.keyDecodingStrategy = .useDefaultKeys
                    do {
                        let result = try jsonDecoder.decode(DepartmentsResponse.self, from: data)
                        completion(result)
                    } catch {
                        completion(nil)
                    }
                }
            }
    }
    
    func search(parameters: [SearchParameter], completion: @escaping (Result<SearchResponse, MetAPIError>) -> Void) {
        self.metAPICache.search(parameters: parameters) { [weak self] searchResponce in
            guard let self = self else {
                completion(.failure(.metAPIdoesNotAnswer))
                return
            }
            if let searchResponce = searchResponce {
                completion(.success(searchResponce))
            } else {
                self.executeSearch(parameters: parameters) {[weak self] realResponse in
                    guard let realResponse = realResponse else {
                        completion(.failure(.noDataInResponce))
                        return
                    }
                    self?.metAPICache.putSearchResponce(parameters: parameters, responceData: realResponse)
                    completion(.success(realResponse))
                }
            }
        }
    }
    
    func executeSearch(parameters: [SearchParameter], completion: @escaping (SearchResponse?) -> Void) {
        var urlString: String = self.urlBaseString
        let urlStringSuffix: String = "public/collection/v1/search"
        urlString.append(urlStringSuffix)
        let searchParameters: [String : String] = self.parameters(from: parameters)
        self.networkManager.get(
            urlString: urlString,
            parameters: searchParameters) { result in
                switch result {
                case .failure:
                    completion(nil)
                case .success(let data):
                    let jsonDecoder = JSONDecoder()
                    jsonDecoder.keyDecodingStrategy = .useDefaultKeys
                    do {
                        let result = try jsonDecoder.decode(SearchResponse.self, from: data)
                        completion(result)
                    } catch {
                        completion(nil)
                    }
                }
            }
    }
    
    private func parameters(from searchParameters: [SearchParameter]) -> [String : String] {
        var parameters: [String : String] = [ : ]
        for parameter in searchParameters {
            switch parameter {
            case .q(let text):
                parameters["q"] = text
            case .isHighlight(let isHighlight):
                parameters["isHighlight"] = self.convertBoolToString(value: isHighlight)
            case .title(let isTitle):
                parameters["title"] = self.convertBoolToString(value: isTitle)
            case .tags(let isTag):
                parameters["tags"] = self.convertBoolToString(value: isTag)
            case .departmentId(let departmentId):
                parameters["departmentId"] = String(departmentId)
            case .isOnView(let isOnView):
                parameters["isOnView"] = self.convertBoolToString(value: isOnView)
            case .artistOrCulture(let isArtistOrCulture):
                parameters["artistOrCulture"] = self.convertBoolToString(value: isArtistOrCulture)
            case .medium(let medium):
                parameters["medium"] = medium
            case .hasImages(let hasImages):
                parameters["hasImages"] = self.convertBoolToString(value: hasImages)
            case .geoLocation(let geoLocation):
                parameters["geoLocation"] = geoLocation
            case .dates(let dates):
                parameters["dates"] = self.covertDatasToString(from: dates.from, to: dates.to)
            }
        }
        return parameters
    }
    
    private func convertBoolToString(value: Bool) -> String {
        if value {
            return ("true")
        } else {
            return ("false")
        }
    }
    
    private func covertDatasToString(from: Int, to: Int) -> String {
        var result: String
        result = String(from)
        result.append("&")
        result.append(String(to))
        return result
    }
}

enum MetAPIError: Error {
    case metAPIdoesNotAnswer
    case noDataInResponce
}
