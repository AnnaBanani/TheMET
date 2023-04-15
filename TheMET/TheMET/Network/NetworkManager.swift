//
//  NetworkManager.swift
//  TheMET
//
//  Created by Анна Ситникова on 21/03/2023.
//

import Foundation

class NetworkManager {
    
    func get(urlString: String, parameters: [String : String], completion: @escaping ([String: Any]?) -> Void)  {
        DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + .milliseconds(Int(12.5)), qos: .background) {
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
        }
    }
    
}




