//
//  ViewController.swift
//  ExchangeRateCalculator
//
//  Created by shinyoungkim on 4/16/25.
//

import UIKit
import SnapKit

final class MainViewController: UIViewController {
    private let exchangeRateTableView = ExchangeRateTableView()
    
    private let exchangeRates: [(country: String, rate: Double)] = [
        ("USA", 1.0),
        ("Korea", 1330.25),
        ("Japan", 154.3),
        ("EU", 0.93)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupTableView()
        setupConstraints()
    }
    
    private func setupViews() {
        view.addSubview(exchangeRateTableView)
    }
    
    private func setupTableView() {
        exchangeRateTableView.dataSource = self
    }
    
    private func setupConstraints() {
        exchangeRateTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exchangeRates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = exchangeRateTableView.dequeueReusableCell(withIdentifier: CellIdentifier.exchangeRate) as? ExchangeRateTableViewCell else {
            return UITableViewCell()
        }
        
        let item = exchangeRates[indexPath.row]
        cell.configure(country: item.country, rate: item.rate)
        
        return cell
    }    
}
