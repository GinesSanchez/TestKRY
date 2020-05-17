//
//  Copyright © Webbhälsa AB. All rights reserved.
//

import Foundation

private let entriesKey = "entries"

protocol WeatherViewModelDelegate {
    func showEntries()
    func displayError()
}

final class WeatherViewModel {
    var viewController: WeatherViewModelDelegate?

    public private(set) var entries: [WeatherLocation] = []

    init() {}

    internal func bind(viewController: WeatherViewModelDelegate) {
        self.viewController = viewController
        refresh()
    }
}

extension WeatherViewModel {
    func refresh() {
        var urlRequest = URLRequest(url: URL(string: "https://app-code-test.kry.pet/locations")!)
        urlRequest.addValue(apiKey, forHTTPHeaderField: "X-Api-Key")
        URLSession(configuration: .default).dataTask(with: urlRequest) { [weak self] (data, response, error) in
                let defaults = UserDefaults.standard
                guard let data = data else {
                    self?.viewController?.displayError()
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

    func removeLocation(index: Int) {
        guard let locationId = entries[index].id else {
            viewController?.displayError()
            return
        }

        var urlRequest = URLRequest(url: URL(string: "https://app-code-test.kry.pet/locations/\(locationId)")!)
        urlRequest.httpMethod = "DELETE"
        urlRequest.addValue(apiKey, forHTTPHeaderField: "X-Api-Key")

        URLSession(configuration: .default).dataTask(with: urlRequest) { [weak self] (data, response, error) in
                if error != nil {
                    self?.viewController?.displayError()
                    return
                }
                self?.refresh()
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

private struct LocationsResult: Codable {
    var locations: [WeatherLocation]
}

private extension WeatherViewModel {
    func decodeAndDisplay(data: Data) {
        do {
            let result = try JSONDecoder().decode(LocationsResult.self, from: data)
            self.entries = result.locations
            self.viewController?.showEntries()
        } catch {
            self.viewController?.displayError()
        }
    }
}
