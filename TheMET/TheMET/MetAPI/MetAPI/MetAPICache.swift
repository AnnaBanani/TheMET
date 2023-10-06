//
//  MetAPICache.swift
//  TheMET
//
//  Created by Анна Ситникова on 25/07/2023.
//

import Foundation

class MetAPICashe {
    
    static let standard: MetAPICashe = MetAPICashe()
    
    private struct CachedData<RequestData, ResponseData> {
        let requestData: RequestData
        let responseData: ResponseData
        let date: Date
        
        init(requestData: RequestData, responseData: ResponseData) {
            self.requestData = requestData
            self.responseData = responseData
            self.date = Date.now
        }
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
        completion(cachedData.responseData)
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
        completion(cachedData.responseData)
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
        completion(cachedData.responseData)
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
        completion(cachedData.responseData)
    }
    
    func putObjectsResponse(metadataDate: Date?, departmentIds: [Int], responseData: ObjectsResponse) {
        let newCachedData = CachedData<ObjectsRequestData, ObjectsResponse>(
            requestData: ObjectsRequestData(metadataDate: metadataDate, departmentIds: departmentIds),
            responseData: responseData
        )
        self.objectsCache.append(newCachedData)
    }
    
    func putObjectResponse(id: ArtID, responseData: ObjectResponse) {
        let newCachedData = CachedData<ArtID, ObjectResponse>(
            requestData: id,
            responseData: responseData
        )
        self.objectCache.append(newCachedData)
    }
    
    func putDepartmentsResponse(responseData: DepartmentsResponse) {
        let newCachedData = CachedData<Void, DepartmentsResponse>(
            requestData: Void(),
            responseData: responseData
        )
        self.departmentsCashe.append(newCachedData)
    }
    
    func putSearchResponse(parameters: [SearchParameter], responseData: SearchResponse) {
        let newCachedData = CachedData<[SearchParameter], SearchResponse>(
            requestData: parameters,
            responseData: responseData
        )
        self.searchCache.append(newCachedData)
    }
}

