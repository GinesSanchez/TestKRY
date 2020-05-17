//
//  Copyright © Webbhälsa AB. All rights reserved.
//

import UIKit

class WeatherViewController: UITableViewController {

    private var controller: WeatherController!

    static func create(controller: WeatherController) -> WeatherViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        let viewController = storyboard.instantiateInitialViewController() as! WeatherViewController

        viewController.controller = controller
        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        controller.bind(view: self)
        setUp()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        controller.refresh()
    }
}

extension WeatherViewController: WeatherView {
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
        return controller.entries.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LocationTableViewCell.reuseIdentifier, for: indexPath) as! LocationTableViewCell

        let entry = controller.entries[indexPath.row]
        cell.setup(entry)

        return cell
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
        let addLocationController = AddLocationController()
        let addLocationVC = AddLocationViewController.create(controller: addLocationController)
        self.navigationController?.pushViewController(addLocationVC, animated: true)
    }
}
