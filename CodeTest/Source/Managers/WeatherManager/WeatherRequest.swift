//
//  WeatherRequest.swift
//  CodeTest
//
//  Created by Gines Sanchez Merono on 2020-05-17.
//  Copyright © 2020 Emmanuel Garnier. All rights reserved.
//

import Foundation

enum WeatherRequest: APIRequest {
    case getWeatherLocations
    case addLocation(data: Data)
    case deleteLocation(id: String)

    var schema: String {
        return "https://"
    }

    var apiHost: String {
        return "app-code-test.kry.pet/"
    }

    var path: String {
        switch self {
        case .deleteLocation(let id):
            return "locations/\(id)"
        default:
            return "locations"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getWeatherLocations:
            return .get
        case .addLocation:
            return .post
        case .deleteLocation:
            return .delete
        }
    }

    var queryParameters: [String : String]? {
        return nil
    }

    var httpHeaders: [String : String]? {
        return [:]
    }

    var bodyData: Data? {
        switch self {
        case .addLocation(let data):
            return data
        default:
            return nil
        }
    }

    var bodyEncoding: HTTPBodyEncoding? {
        return .json
    }
}
