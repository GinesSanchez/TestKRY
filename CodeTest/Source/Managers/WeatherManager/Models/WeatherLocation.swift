//
//  Copyright © Webbhälsa AB. All rights reserved.
//

import UIKit

struct WeatherLocation: Codable {
    enum Status: String, Codable, CaseIterable {
        case cloudy = "CLOUDY"
        case sunny = "SUNNY"
        case mostlySunny = "MOSTLY_SUNNY"
        case partlySunnyRain = "PARTLY_SUNNY_RAIN"
        case thunderCloudAndRain = "THUNDER_CLOUD_AND_RAIN"
        case tornado = "TORNADO"
        case barelySunny = "BARELY_SUNNY"
        case lightening = "LIGHTENING"
        case snowCloud = "SNOW_CLOUD"
        case rainy = "RAINY"
    }
    let id: String?
    let name: String
    let status: Status
    let temperature: Int
}

extension WeatherLocation.Status {
    var translatedStatus: String {
        switch self {
        case .cloudy:
            return "Cloudy"
        case .sunny:
            return "Sunny"
        case .mostlySunny:
            return "Mostly Sunny"
        case .partlySunnyRain:
            return "Partly Sunny and Rainy"
        case .thunderCloudAndRain:
            return "Thunder, Cloudy and Rainy"
        case .tornado:
            return "Tornado"
        case .barelySunny:
            return "Barely Sunny"
        case .lightening:
            return "Lightening"
        case .snowCloud:
            return "Snowy and Cloudy"
        case .rainy:
            return "Rainy"
        }
    }
}
