//
//  APIManager.swift
//  K3TestTask
//
//  Created by Evgeniya Ignatyeva on 3/28/19.
//  Copyright © 2019 Evgeniya Ignatyeva. All rights reserved.
//

import Foundation

class APIManager {
    let urlSession = URLSession.shared
    func request(_ endpoint: Endpoint,
                 then handler: @escaping (Data?, Error?) -> Void) {
        guard let url = endpoint.url else {
            print("Invalid URL in request")
            return
        }
        
        let task = urlSession.dataTask(with: url) {data, response, error in
            guard error == nil else {
                print ("get(): Server Error: \(String(describing: error))")
                handler(nil, error)
                return
            }
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                print ("get(): Server Error with bad status code")
                return
            }
            if  let data = data,
                let dataString = String(data: data, encoding: .utf8) {
                print("get(): Echo Responce: \(dataString)")
                handler(data, nil)
            }
        }
        task.resume()
    }
}

struct Endpoint {
    let path: String
    let queryItems: [URLQueryItem]
}

extension Endpoint {
    static func search(matching text: String, before timestamp: Int) -> Endpoint {
        return Endpoint(
            path: "/v2/tagged",
            queryItems: [
                URLQueryItem(name: "tag", value: text),
                URLQueryItem(name: "before", value: String(timestamp)),
                URLQueryItem(name: "api_key", value: "CcEqqSrYdQ5qTHFWssSMof4tPZ89sfx6AXYNQ4eoXHMgPJE03U")
            ]
        )
    }
}
extension Endpoint {
    var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.tumblr.com"
        components.path = path
        components.queryItems = queryItems
        return components.url
    }
}
