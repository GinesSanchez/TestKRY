//
//  AddLocationViewController.swift
//  CodeTest
//
//  Created by Gines Sanchez Merono on 2020-05-17.
//  Copyright © 2020 Emmanuel Garnier. All rights reserved.
//

import UIKit


final class AddLocationViewController: UIViewController {

    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var cityNameText: UITextField!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var temperatureText: UITextField!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var statusText: UITextField!
    @IBOutlet weak var pickerView: UIPickerView!

    private var controller: AddLocationController!

    private let statusArray =  [WeatherLocation.Status.cloudy,
                                WeatherLocation.Status.sunny,
                                WeatherLocation.Status.mostlySunny,
                                WeatherLocation.Status.partlySunnyRain,
                                WeatherLocation.Status.thunderCloudAndRain,
                                WeatherLocation.Status.tornado,
                                WeatherLocation.Status.barelySunny,
                                WeatherLocation.Status.lightening,
                                WeatherLocation.Status.snowCloud,
                                WeatherLocation.Status.rainy]

    static func create(controller: AddLocationController) -> AddLocationViewController {
        let viewController = AddLocationViewController.init(nibName: "AddLocationViewController", bundle: nil)

        viewController.controller = controller
        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        controller.bind(view: self)
        setUp()
    }
}

extension AddLocationViewController: AddLocationView {
    func displayError() {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Error", message: "We couldn't add the new location. Please, try again", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertController, animated: true)
        }
    }

    func goBack() {
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }
    }
}

// MARK: - Set Up
private extension AddLocationViewController {
    func setUp() {
        setUpNavigationBar()
        setUpLabels()
        setUpTexts()
        setUpPickerView()
    }

    func setUpNavigationBar() {
        title = "Add Location"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addTapped))
    }

    func setUpLabels() {
        cityNameLabel.text = "City Name"
        temperatureLabel.text = "Temperature"
        statusLabel.text = "Status"
    }

    func setUpTexts() {
        cityNameText.placeholder = "i.g. New York"
        temperatureText.placeholder = "i.g. 22"
        statusText.placeholder = "i.g. Sunny"

        cityNameText.becomeFirstResponder()
        statusText.inputView = pickerView
    }

    func setUpPickerView() {
        pickerView.dataSource = self
        pickerView.delegate = self
    }
}

// MARK: - PickerView Delegate and DataSource
extension AddLocationViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return statusArray.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return statusArray[row].translatedStatus
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        statusText.text = statusArray[row].translatedStatus
    }
}

// MARK: - IBActions
private extension AddLocationViewController {
    @objc func addTapped() {
        let status = statusArray.filter { (status) -> Bool in
            return status.translatedStatus == statusText.text
        }.first
        controller.addLocationWith(cityName: cityNameText.text, temperature: temperatureText.text, status: status)
    }
}
