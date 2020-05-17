//
//  WeatherManager.swift
//  CodeTest
//
//  Created by Gines Sanchez Merono on 2020-05-17.
//  Copyright © 2020 Emmanuel Garnier. All rights reserved.
//

import Foundation

private let entriesKey = "entries"

enum WeatherManagerError: Error {
    case wrongRequestData
    case wrongRequestUrl
    case responseError
    case noResponseData
    case invalidResponse
    case invalidJson
    case invalidResponseCode
    case fieldMissing
    case unknown
}

protocol WeatherManagerType {
    var networkManager: NetworkManagerType { get }
    init(networkManager: NetworkManagerType)
    func getWeatherLocations(completion: @escaping (Result<[WeatherLocation], WeatherManagerError>) -> Void)
    func add(weatherLocation: WeatherLocation, completion: @escaping (Result<WeatherLocation, WeatherManagerError>) -> Void)
    func delete(weatherLocation: WeatherLocation, completion: @escaping (Result<Void, WeatherManagerError>) -> Void)
    func getWeatherLocationsCachedData() -> [WeatherLocation]
}

final class WeatherManager: WeatherManagerType {
    var networkManager: NetworkManagerType

    init(networkManager: NetworkManagerType) {
        self.networkManager = networkManager
        return
    }

    func getWeatherLocations(completion: @escaping (Result<[WeatherLocation], WeatherManagerError>) -> Void) {
        guard let urlRequest = WeatherRequest.getWeatherLocations.urlRequest else {
            return completion(.failure(.wrongRequestUrl))
        }
        networkManager.execute(urlRequest: urlRequest) { (data, response, error) in
            guard error == nil else {
                return completion(.failure(.responseError))
            }

            guard let data = data else {
                return completion(.failure(.noResponseData))
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                return completion(.failure(.invalidResponse))
            }

            switch httpResponse.statusCode {
            case 200:
                do {
                    let userDefaults = UserDefaults.standard
                    userDefaults.set(data, forKey: entriesKey)
                    let weatherLocationsResponse = try JSONDecoder().decode(WeatherLocationsResponse.self, from: data)
                    completion(.success(weatherLocationsResponse.locations))
                } catch {
                    return completion(.failure(.invalidJson))
                }
                break
            case 400:
                return completion(.failure(.fieldMissing))
            case 500:
                return completion(.failure(.unknown))
            default:
                return completion(.failure(.invalidResponseCode))
            }
        }
    }

    func add(weatherLocation: WeatherLocation, completion: @escaping (Result<WeatherLocation, WeatherManagerError>) -> Void) {
        guard let jsonData = try? JSONEncoder().encode(weatherLocation) else {
            return completion(.failure(.wrongRequestData))
        }
        guard let urlRequest = WeatherRequest.addLocation(data: jsonData).urlRequest else {
            return completion(.failure(.wrongRequestUrl))
        }
        networkManager.execute(urlRequest: urlRequest) { (data, response, error) in
            guard error == nil else {
                return completion(.failure(.responseError))
            }

            guard let data = data else {
                return completion(.failure(.noResponseData))
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                return completion(.failure(.invalidResponse))
            }

            switch httpResponse.statusCode {
            case 200:
                do {
                    let weatherLocation = try JSONDecoder().decode(WeatherLocation.self, from: data)
                    completion(.success(weatherLocation))
                } catch {
                    return completion(.failure(.invalidJson))
                }
                break
            case 400:
                return completion(.failure(.fieldMissing))
            case 500:
                return completion(.failure(.unknown))
            default:
                return completion(.failure(.invalidResponseCode))
            }
        }
    }

    func delete(weatherLocation: WeatherLocation, completion: @escaping (Result<Void, WeatherManagerError>) -> Void) {
        guard let id = weatherLocation.id else {
            return completion(.failure(.wrongRequestData))
        }

        guard let urlRequest = WeatherRequest.deleteLocation(id: id).urlRequest else {
            return completion(.failure(.wrongRequestUrl))
        }
        networkManager.execute(urlRequest: urlRequest) { (data, response, error) in
            guard error == nil else {
                return completion(.failure(.responseError))
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                return completion(.failure(.invalidResponse))
            }

            switch httpResponse.statusCode {
            case 200:
                completion(.success(()))
            case 400:
                return completion(.failure(.fieldMissing))
            case 500:
                return completion(.failure(.unknown))
            default:
                return completion(.failure(.invalidResponseCode))
            }
        }
    }

    func getWeatherLocationsCachedData() -> [WeatherLocation] {
        let userDefaults = UserDefaults.standard
        guard let userDefaultsData = userDefaults.object(forKey: entriesKey) as? Data else {
            return []
        }

        do {
            let result = try JSONDecoder().decode(WeatherLocationsResponse.self, from: userDefaultsData)
            return result.locations
        } catch {
            return []
        }
    }
}
