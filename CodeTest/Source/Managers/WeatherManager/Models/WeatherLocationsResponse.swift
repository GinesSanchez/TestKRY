//
//  WeatherLocationsResponse.swift
//  CodeTest
//
//  Created by Gines Sanchez Merono on 2020-05-17.
//  Copyright © 2020 Emmanuel Garnier. All rights reserved.
//

import Foundation

struct WeatherLocationsResponse: Decodable {
    let locations: [WeatherLocation]
}

