//
//  Copyright © Webbhälsa AB. All rights reserved.
//

import Foundation

private let entriesKey = "entries"

protocol WeatherView {
    func showEntries()
    func displayError()
}

class WeatherController {
    var view: WeatherView?

    public private(set) var entries: [WeatherLocation] = []

    init() {}

    internal func bind(view: WeatherView) {
        self.view = view
        refresh()
    }
}

extension WeatherController {
    func refresh() {
        var urlRequest = URLRequest(url: URL(string: "https://app-code-test.kry.pet/locations")!)
        urlRequest.addValue(apiKey, forHTTPHeaderField: "X-Api-Key")
        URLSession(configuration: .default).dataTask(with: urlRequest) { [weak self] (data, response, error) in
                let defaults = UserDefaults.standard
                guard let data = data else {
                    self?.view?.displayError()
                    guard let userDefaultsData = defaults.object(forKey: entriesKey) as? Data else {
                        return
                    }
                    self?.decodeAndDisplay(data: userDefaultsData)
                    return
                }
                defaults.set(data, forKey: entriesKey)
                self?.decodeAndDisplay(data: data)
        }.resume()
    }

    var apiKey: String {
        guard let apiKey = UserDefaults.standard.string(forKey: "API_KEY") else {
            let key = UUID().uuidString
            UserDefaults.standard.set(key, forKey: "API_KEY")
            return key
        }
        return apiKey
    }
}

private struct LocationsResult: Decodable {
    var locations: [WeatherLocation]
}

private extension WeatherController {
    func decodeAndDisplay(data: Data) {
        do {
            let result = try JSONDecoder().decode(LocationsResult.self, from: data)
            self.entries = result.locations
            self.view?.showEntries()
        } catch {
            self.view?.displayError()
        }
    }
}
