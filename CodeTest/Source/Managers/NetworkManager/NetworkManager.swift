//
//  NetworkManager.swift
//  CodeTest
//
//  Created by Gines Sanchez Merono on 2020-05-17.
//  Copyright © 2020 Emmanuel Garnier. All rights reserved.
//

import Foundation

protocol NetworkManagerType {
    func execute(urlRequest: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void)
}

final class NetworkManager: NetworkManagerType {
    func execute(urlRequest: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        URLSession.shared.dataTask(with: urlRequest, completionHandler: completion).resume()
    }
}
