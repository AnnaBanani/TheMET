//
//  MetAPICache.swift
//  TheMET
//
//  Created by Анна Ситникова on 25/07/2023.
//

import Foundation

class MetAPICashe {
    
    static let standard: MetAPICashe = MetAPICashe()
    
    private struct CachedData<RequestData, ResponceData> {
        let requestData: RequestData
        let responceData: ResponceData
        let date: Date
    }
    
    private struct ObjectsRequestData {
        let metadataDate: Date?
        let departmentIds: [Int]
    }
    
    private var objectsCache: [CachedData<ObjectsRequestData, ObjectsResponse>] = []
    private var objectCache: [CachedData<ArtID, ObjectResponse>] = []
    private var departmentsCashe: [CachedData<Void,DepartmentsResponse>] = []
    private var searchCache: [CachedData<[SearchParameter], SearchResponse>] = []
    
    private func isTimeIntervalLessEnough(lastRequest: Date) -> Bool {
        let currentDate = Date()
        let differenceInSeconds = lastRequest.distance(to: currentDate)
        let requiedTimeInterval: TimeInterval = 300
        return differenceInSeconds < requiedTimeInterval
    }
    
    
    func objects(metadataDate: Date? = nil, departmentIds: [Int] = [], completion: @escaping (ObjectsResponse?) -> Void) {
        self.objectsCache.removeAll { data in
            !self.isTimeIntervalLessEnough(lastRequest: data.date)
        }
        guard let cachedData = self.objectsCache.first(where: { data in
            return data.requestData.departmentIds == departmentIds
            && data.requestData.metadataDate == metadataDate
            && self.isTimeIntervalLessEnough(lastRequest: data.date)
        }) else {
            completion(nil)
            return
        }
        completion(cachedData.responceData)
    }
    
    func object(id: ArtID, completion: @escaping (ObjectResponse?) -> Void) {
        self.objectCache.removeAll { data in
            !self.isTimeIntervalLessEnough(lastRequest: data.date)
        }
        guard let cachedData = self.objectCache.first(where: { data in
            return data.requestData == id
            && self.isTimeIntervalLessEnough(lastRequest: data.date)
        }) else {
            completion(nil)
            return
        }
        completion(cachedData.responceData)
    }

    func departments(completion: @escaping (DepartmentsResponse?) -> Void) {
        self.departmentsCashe.removeAll { data in
            !self.isTimeIntervalLessEnough(lastRequest: data.date)
        }
        guard let cachedData = self.departmentsCashe.first(where: { data in
            self.isTimeIntervalLessEnough(lastRequest: data.date)
        }) else {
            completion(nil)
            return
        }
        completion(cachedData.responceData)
    }
    
    func search(parameters: [SearchParameter], completion: @escaping (SearchResponse?) -> Void) {
        self.searchCache.removeAll { data in
            !self.isTimeIntervalLessEnough(lastRequest: data.date)
        }
        guard let cachedData = self.searchCache.first(where: { data in
            return data.requestData == parameters
            && self.isTimeIntervalLessEnough(lastRequest: data.date)
        }) else {
            completion(nil)
            return
        }
        completion(cachedData.responceData)
    }
    
    func putObjectsResponce(metadataDate: Date?, departmentIds: [Int], responceData: ObjectsResponse) {
        let newCachedData = CachedData<ObjectsRequestData, ObjectsResponse>(
            requestData: ObjectsRequestData(metadataDate: metadataDate, departmentIds: departmentIds),
            responceData: responceData,
            date: Date.now
        )
        self.objectsCache.append(newCachedData)
    }
    
    func putObjectResponce(requestData: ArtID, responceData: ObjectResponse) {
        let newCachedData = CachedData<ArtID, ObjectResponse>(
        requestData: requestData,
        responceData: responceData,
        date: Date.now
        )
        self.objectCache.append(newCachedData)
    }
    
    func putDepartmentsResponce(responceData: DepartmentsResponse) {
        let newCachedData = CachedData<Void, DepartmentsResponse>(
        requestData: Void(),
        responceData: responceData,
        date: Date.now
        )
        self.departmentsCashe.append(newCachedData)
    }
    
    func putSearchResponce(requestData: [SearchParameter], responceData: SearchResponse) {
        let newCachedData = CachedData<[SearchParameter], SearchResponse>(
        requestData: requestData,
        responceData: responceData,
        date: Date.now
        )
        self.searchCache.append(newCachedData)
    }
}

