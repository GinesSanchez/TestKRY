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
    private var entries: [WeatherLocation] = []
}

extension WeatherViewModel: WeatherViewControllerDelegate {
    
    func bind(viewController: WeatherViewModelDelegate) {
        self.viewController = viewController
        refresh()
    }

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

    func removeWeatherLocation(index: Int) {
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

    var numberOfRowsInSection: Int {
        return entries.count
    }

    func weatherLocationFor(index: Int) -> WeatherLocation {
        return entries[index]
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

// MARK: - Computed Properties
private extension WeatherViewModel {
    private var apiKey: String {
        guard let apiKey = UserDefaults.standard.string(forKey: "API_KEY") else {
            let key = UUID().uuidString
            UserDefaults.standard.set(key, forKey: "API_KEY")
            return key
        }
        return apiKey
    }
}
