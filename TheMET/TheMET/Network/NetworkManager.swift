//
//  NetworkManager.swift
//  TheMET
//
//  Created by Анна Ситникова on 21/03/2023.
//

import Foundation

class NetworkManager {
    
    private init() {
    }
    
    static let standard: NetworkManager = NetworkManager()
    
    private var lastRequestTime = Date.distantPast
    
//    func get(urlString: String, parameters: [String : String], completion: @escaping (Data?) -> Void)  {
//        if self.isTimeIntervalLongEnough(lastRequest: lastRequestTime) {
//            self.executeNetworkGet(urlString: urlString, parameters: parameters, completion: completion)
//        } else {
//            DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + .microseconds(Int(12500))) { [weak self] in
//                self?.get(urlString: urlString, parameters: parameters, completion: completion)
//            }
//        }
//    }
    
    func get(urlString: String, parameters: [String : String], completion: @escaping (Result<Data, NetworkManagerError>) -> Void)  {
        if self.isTimeIntervalLongEnough(lastRequest: lastRequestTime) {
            self.executeNetworkGet(urlString: urlString, parameters: parameters, completion: completion)
        } else {
            DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + .microseconds(Int(12500))) { [weak self] in
                self?.get(urlString: urlString, parameters: parameters, completion: completion)
            }
        }
    }
    
    private func executeNetworkGet(urlString: String, parameters: [String : String], completion: @escaping (Result<Data, NetworkManagerError>) -> Void)  {
        guard var components = URLComponents(string: urlString) else {
            completion(.failure(.invalidUrlString))
            return
        }
        components.queryItems = parameters.map { (key, value) in
            URLQueryItem(name: key, value: value)
        }
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        guard let url = components.url else {
            completion(.failure(.invalidUrlComponents))
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        let urlSession = URLSession.shared
        let requestTask = urlSession.dataTask(
            with: urlRequest
        ) { data, _, error in
            let executeCompletionOnMain: (Result<Data, NetworkManagerError>) -> Void = { result in
                DispatchQueue.main.async {
                    completion(result)
                }
            }
            if let error = error {
                executeCompletionOnMain(.failure(.urlSessionTaskError(error)))
                return
            }
            guard let data = data else {
                executeCompletionOnMain(.failure(.noDataInResponce))
                return
            }
            executeCompletionOnMain(.success(data))
        }
        requestTask.resume()
        lastRequestTime = .now
    }
    
    private func isTimeIntervalLongEnough(lastRequest: Date) -> Bool {
        let currentDate = Date()
        let differenceInSeconds = lastRequest.distance(to: currentDate)
        let requiedTimeInterval: TimeInterval = 0.0125
        return differenceInSeconds > requiedTimeInterval
    }
}

enum NetworkManagerError: Error {
    case invalidUrlString
    case invalidUrlComponents
    case urlSessionTaskError(Error)
    case noDataInResponce
}




