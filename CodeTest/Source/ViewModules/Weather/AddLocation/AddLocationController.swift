//
//  AddLocationController.swift
//  CodeTest
//
//  Created by Gines Sanchez Merono on 2020-05-17.
//  Copyright © 2020 Emmanuel Garnier. All rights reserved.
//

import Foundation

protocol AddLocationView {
    func displayError()
    func goBack()
}

final class AddLocationController {
    private var view: AddLocationView?

    init() {}

    internal func bind(view: AddLocationView) {
        self.view = view
    }

    internal func addLocationWith(cityName: String?, temperature: String?, status: WeatherLocation.Status?) {
        guard let cityName = cityName, let status = status, let temperature = temperature, let temperatureInt = Int(temperature) else {
            //TODO: Show pararameters missings
            return
        }
        let weatherLocation = WeatherLocation(id: nil, name: cityName, status: status, temperature: temperatureInt)
        let jsonData = try? JSONEncoder().encode(weatherLocation)

        var urlRequest = URLRequest(url: URL(string: "https://app-code-test.kry.pet/locations")!)
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = jsonData
        urlRequest.addValue(apiKey, forHTTPHeaderField: "X-Api-Key")
        
        URLSession(configuration: .default).dataTask(with: urlRequest) { [weak self] (data, response, error) in
                guard let data = data else {
                    self?.view?.displayError()
                    return
                }
                do {
                    _ = try JSONDecoder().decode(WeatherLocation.self, from: data)
                    self?.view?.goBack()
                } catch {
                    self?.view?.displayError()
                }
        }.resume()
    }

    private var apiKey: String {
        guard let apiKey = UserDefaults.standard.string(forKey: "API_KEY") else {
            let key = UUID().uuidString
            UserDefaults.standard.set(key, forKey: "API_KEY")
            return key
        }
        return apiKey
    }
}
