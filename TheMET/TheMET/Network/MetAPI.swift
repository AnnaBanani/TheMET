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
        } else {
            dateString = nil
        }
        let idArrayString: String?
        if !departmentIds.isEmpty {
            idArrayString = departmentIds.map {String($0)}.joined(separator: "|")
            parameters.updateValue(idArrayString!, forKey: "departmentIds")
        }
        if let date =  dateString {
            parameters.updateValue(date, forKey: "metadataDate")
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

}
