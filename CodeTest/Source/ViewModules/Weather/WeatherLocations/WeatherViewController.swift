//
//  Copyright © Webbhälsa AB. All rights reserved.
//

import UIKit

protocol WeatherViewControllerDelegate {
    func bind(viewController: WeatherViewModelDelegate)
    func refresh()
    func removeWeatherLocation(index: Int)

    var numberOfRowsInSection: Int { get }
    func weatherLocationFor(index: Int) -> WeatherLocation

}

final class WeatherViewController: UITableViewController {

    var viewModel: WeatherViewControllerDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.bind(viewController: self)
        setUp()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.refresh()
    }
}

extension WeatherViewController: WeatherViewModelDelegate {
    func showEntries() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    func displayError() {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Error", message: "Something went wrong", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertController, animated: true)
        }
    }
}

extension WeatherViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LocationTableViewCell.reuseIdentifier, for: indexPath) as! LocationTableViewCell
        cell.setup(viewModel.weatherLocationFor(index: indexPath.row))

        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.removeWeatherLocation(index: indexPath.row)
        }
    }
}

// MARK: - Set up
private extension WeatherViewController {
    func setUp() {
        setUpTableView()
        setUpNavigationBar()
    }

    func setUpTableView() {
        tableView.tableFooterView = UIView()
        tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
    }

    func setUpNavigationBar() {
        title = "Weather Code Test"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
    }
}

// MARK: - IBActions
private extension WeatherViewController {
    @objc func addTapped() {
        let addLocationVC = AddLocationViewController.init(nibName: "AddLocationViewController", bundle: nil)
        addLocationVC.viewModel = AddLocationViewModel()
        self.navigationController?.pushViewController(addLocationVC, animated: true)
    }
}
