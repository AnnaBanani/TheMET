//
//  MetAPI.swift
//  TheMET
//
//  Created by Анна Ситникова on 25/04/2023.
//

import Foundation

class MetAPI{
    
    private var networkManager: NetworkManager
    
    private let urlBaseString: String = "https://collectionapi.metmuseum.org/"
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    func objects(metadataDate: Date? = nil, departmentIds: [Int] = [], completion: @escaping (ObjectsResponse?) -> Void) {
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
            parameters: parameters) { data in
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .useDefaultKeys
                if let data = data {
                    do {
                        let result = try jsonDecoder.decode(ObjectsResponse.self, from: data)
                        completion(result)
                    } catch {
                        completion(nil)
                    }
                } else {
                    completion(nil)
                }
            }
    }
    
    func object(id: Int, completion: @escaping (ObjectResponse?) -> Void) {
        var urlString: String = self.urlBaseString
        let urlStringSuffix: String = "public/collection/v1/objects/\(id)"
        urlString.append(urlStringSuffix)
        self.networkManager.get(
            urlString: urlString,
            parameters: [ : ]) { data in
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .useDefaultKeys
                if let data = data {
                    do {
                        let result = try jsonDecoder.decode(ObjectResponse.self, from: data)
                        completion(result)
                    } catch {
                        completion(nil)
                    }
                } else {
                    completion(nil)
                }
            }
    }
    
    func search(parameters: [SearchParameter], completion: @escaping (SearchResponse?) -> Void) {
        var urlString: String = self.urlBaseString
        let urlStringSuffix: String = "public/collection/v1/search"
        urlString.append(urlStringSuffix)
        var searchParameters: [String : String] = self.fillingParameters(parameters: parameters)
        self.networkManager.get(
            urlString: urlString,
            parameters: searchParameters) { data in
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .useDefaultKeys
                if let data = data {
                    do {
                        let result = try jsonDecoder.decode(SearchResponse.self, from: data)
                        completion(result)
                    } catch {
                        completion(nil)
                    }
                } else {
                    completion(nil)
                }
            }
    }
    
    private func fillingParameters (parameters: [SearchParameter]) -> [String : String] {
        var searchParameters: [String : String] = [ : ]
        for parameter in parameters {
            switch parameter {
            case .q(let text):
                searchParameters["q"] = text
            case .isHighlight(let bool):
                searchParameters["isHighlight"] = self.convertBoolToString(value: bool)
            case .title(let bool):
                searchParameters["title"] = self.convertBoolToString(value: bool)
            case .tags(let bool):
                searchParameters["tags"] = self.convertBoolToString(value: bool)
            case .departmentId(let departmentId):
                searchParameters["departmentId"] = String(departmentId)
            case .isOnView(let bool):
                searchParameters["isOnView"] = self.convertBoolToString(value: bool)
            case .artistOrCulture(let bool):
                searchParameters["artistOrCulture"] = self.convertBoolToString(value: bool)
            case .medium(let medium):
                searchParameters["medium"] = medium
            case .hasImages(let bool):
                searchParameters["hasImages"] = self.convertBoolToString(value: bool)
            case .geoLocation(let geoLocation):
                searchParameters["geoLocation"] = geoLocation
            case .dates(let dates):
                searchParameters["dates"] = self.covertDatasToString(from: dates.from, to: dates.to)
            }
        }
        return searchParameters
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
        result = String(describing: from)
        result.append("&")
        result.append(String(describing: to))
        return result
    }
}
