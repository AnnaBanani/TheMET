//
//  NetworkManager.swift
//  TheMET
//
//  Created by Анна Ситникова on 21/03/2023.
//

import Foundation

class NetworkManager {
    
    func loadData(urlString: String, parameters: [String : String], completion: @escaping([String: Any]?) -> Void)  {
        guard var components = URLComponents(string: urlString) else {
            completion(nil)
            return
        }
        components.queryItems = parameters.map{ (key, value) in
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
        ) { data, urlResponse, error in
            let executeCompletionOnMain: ([String: Any]?) -> Void = { loadedData in
                DispatchQueue.main.async {
                    completion(loadedData)
                }
            }
            guard error == nil,
                  let data = data,
                  let _ = urlResponse as? HTTPURLResponse else {
                executeCompletionOnMain(nil)
                return
            }
            let result = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
            executeCompletionOnMain(result)
        }
        fileDownloadTask.resume()
    }
    
}




