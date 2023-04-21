//
//  NetworkManager.swift
//  TheMET
//
//  Created by Анна Ситникова on 21/03/2023.
//

import Foundation

class NetworkManager {
    
    private var lastRequestTime = Date.distantPast
    
    func get(urlString: String, parameters: [String : String], completion: @escaping ([String: Any]?) -> Void)  {
        if self.isTimeIntervalLongEnough(lastRequest: lastRequestTime) {
            self.executeNetworkGet(urlString: urlString, parameters: parameters, completion: completion)
        } else {
            DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + .microseconds(Int(12500))) { [weak self] in
                self?.get(urlString: urlString, parameters: parameters, completion: completion)
            }
        }
    }
    
    private func executeNetworkGet(urlString: String, parameters: [String : String], completion: @escaping ([String: Any]?) -> Void)  {
        guard var components = URLComponents(string: urlString) else {
            completion(nil)
            return
        }
        components.queryItems = parameters.map { (key, value) in
            URLQueryItem(name: key, value: value)
        }
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        guard let url = components.url else {
            completion(nil)
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        let urlSession = URLSession.shared
        let fileDownloadTask = urlSession.dataTask(
            with: urlRequest
        ) { data, _, error in
            let executeCompletionOnMain: ([String: Any]?) -> Void = { loadedData in
                DispatchQueue.main.async {
                    completion(loadedData)
                }
            }
            guard error == nil,
                  let data = data else {
                executeCompletionOnMain(nil)
                return
            }
            let result = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
            executeCompletionOnMain(result)
        }
        fileDownloadTask.resume()
        lastRequestTime = .now
    }
    
    private func isTimeIntervalLongEnough(lastRequest: Date) -> Bool {
        let currentDate = Date()
        let differenceInSeconds = currentDate.distance(to: lastRequest)
        let requiedTimeInterval: TimeInterval = 0.0125
        return differenceInSeconds > requiedTimeInterval
    }
}




