//
//  MetAPI.swift
//  TheMET
//
//  Created by Анна Ситникова on 25/04/2023.
//

import Foundation

class MetAPI{
    
    private var networkManager: NetworkManager
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    func objects(metadataDate: Date? = nil, departmentIds: [Int] = [], completion: @escaping (ObjectsResponse?) -> Void) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString: String?
        if let date = metadataDate {
            dateString = dateFormatter.string(from: date)
        } else {
            dateString = nil
        }
        let idArrayString: String?
        if !departmentIds.isEmpty {
            idArrayString = departmentIds.map {String($0)}.joined(separator: "|")
        } else {
            idArrayString = nil
        }
        let urlString: String = "https://collectionapi.metmuseum.org/public/collection/v1/objects"
        var parameters: [String : String]
        if let date =  dateString,
           let arrayString = idArrayString {
           parameters = ["metadataDate" : date, "departmentIds" : arrayString]
        } else if let date =  dateString {
            parameters = ["metadataDate" : date]
        } else if let arrayString = idArrayString {
            parameters = ["departmentIds" : arrayString]
        } else {
            parameters = [ : ]
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
