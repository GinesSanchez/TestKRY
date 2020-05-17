//
//  APIRequest.swift
//  CodeTest
//
//  Created by Gines Sanchez Merono on 2020-05-17.
//  Copyright © 2020 Emmanuel Garnier. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case get
    case post
    case put
    case patch
    case delete
}

enum HTTPBodyEncoding {
    case json
    case url
}

protocol APIRequest {
    var schema: String { get }
    var apiHost: String { get }
    var path: String { get }
    var method: HTTPMethod { get }

    //Optional
    var queryParameters: [String: String]? { get }
    var httpHeaders: [String: String]? {get}
    var bodyData: Data? {get}
    var bodyEncoding: HTTPBodyEncoding? {get}

    var urlRequest: URLRequest? {get}
}

extension APIRequest {
    var urlRequest: URLRequest? {
        let urlPath = schema + apiHost + path
        guard var urlComponents = URLComponents(string: urlPath) else {return nil}
        urlComponents.queryItems = queryParameters?.map { URLQueryItem(name: $0, value: $1) }

        if let url = urlComponents.url {
            var request = URLRequest(url: url)
            request.httpMethod = method.rawValue.capitalized
            request.allHTTPHeaderFields = httpHeaders
            request.httpBody = bodyData
            request.addValue(apiKey, forHTTPHeaderField: "X-Api-Key")

            return request
        }
        return nil
    }
}

private var apiKey: String {
    guard let apiKey = UserDefaults.standard.string(forKey: "API_KEY") else {
        let key = UUID().uuidString
        UserDefaults.standard.set(key, forKey: "API_KEY")
        return key
    }
    return apiKey
}
