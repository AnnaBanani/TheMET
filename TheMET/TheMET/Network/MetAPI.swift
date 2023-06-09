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

    func departments(completion: @escaping (DepartmentsResponse?) -> Void) {
        var urlString: String = self.urlBaseString
        let urlStringSuffix: String = "public/collection/v1/departments"
        urlString.append(urlStringSuffix)
        self.networkManager.get(
            urlString: urlString,
            parameters: [ : ]) { data in
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .useDefaultKeys
                if let data = data {
                    do {
                        let result = try jsonDecoder.decode(DepartmentsResponse.self, from: data)
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
        let searchParameters: [String : String] = self.parameters(from: parameters)
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
