//
//  AddLocationViewModel.swift
//  CodeTest
//
//  Created by Gines Sanchez Merono on 2020-05-17.
//  Copyright © 2020 Emmanuel Garnier. All rights reserved.
//

import Foundation

protocol AddLocationViewModelDelegate: class {
    func displayError()
    func goBack()
}

final class AddLocationViewModel {
    private weak var viewController: AddLocationViewModelDelegate?
    private let weatherManager: WeatherManagerType

    init(weatherManager: WeatherManagerType) {
        self.weatherManager = weatherManager
        return
    }
}

// MARK: - AddLocationViewControllerDelegate
extension AddLocationViewModel: AddLocationViewControllerDelegate {
    func bind(viewController: AddLocationViewModelDelegate) {
        self.viewController = viewController
    }

    func addLocationWith(cityName: String?, temperature: String?, status: WeatherLocation.Status?) {
        guard let cityName = cityName, let status = status, let temperature = temperature, let temperatureInt = Int(temperature) else {
            viewController?.displayError()
            return
        }
        let weatherLocation = WeatherLocation(id: nil, name: cityName, status: status, temperature: temperatureInt)

        weatherManager.add(weatherLocation: weatherLocation) { [weak self] (result) in
            switch result {
            case .failure:
                self?.viewController?.displayError()
            case .success:
                self?.viewController?.goBack()
            }
        }
    }
}
