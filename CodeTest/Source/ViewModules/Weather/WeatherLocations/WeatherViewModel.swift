//
//  Copyright © Webbhälsa AB. All rights reserved.
//

import Foundation

protocol WeatherViewModelDelegate {
    func showEntries()
    func displayError()
}

final class WeatherViewModel {
    var viewController: WeatherViewModelDelegate?
    private var entries: [WeatherLocation] = []

    private let weatherManager: WeatherManagerType

    init(weatherManager: WeatherManagerType) {
        self.weatherManager = weatherManager
        return
    }
}

extension WeatherViewModel: WeatherViewControllerDelegate {
    
    func bind(viewController: WeatherViewModelDelegate) {
        self.viewController = viewController
        refresh()
    }

    func refresh() {
        weatherManager.getWeatherLocations { [weak self] result in
            switch result {
            case .failure:
                self?.viewController?.displayError()
                guard let entries = self?.weatherManager.getWeatherLocationsCachedData() else {
                    return
                }
                self?.entries = entries
            case .success(let entries):
                self?.entries = entries
            }
            self?.viewController?.showEntries()
        }
    }

    func removeWeatherLocation(index: Int) {
        weatherManager.delete(weatherLocation: entries[index]) { [weak self] (result) in
            switch result {
            case .failure:
                self?.viewController?.displayError()
            case .success:
                self?.refresh()
            }
        }
    }

    var numberOfRowsInSection: Int {
        return entries.count
    }

    func weatherLocationFor(index: Int) -> WeatherLocation {
        return entries[index]
    }
}
