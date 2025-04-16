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
    
    private let exchangeRateService = ExchangeRateService()
    
    private var exchangeRates = [(country: String, rate: Double)]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupTableView()
        setupConstraints()
        fetchExchangeRateData()
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
    
    private func fetchExchangeRateData() {
        let urlComponents = URLComponents(string: API.latestRates)
        
        guard let url = urlComponents?.url else {
            print("잘못된 URL")
            return
        }
        
        exchangeRateService.fetchData(url: url) { [weak self] (result: ExchangeRateResult?) in
            guard let self else { return }
            guard let result else {
                DispatchQueue.main.async {
                    self.showAlert(title: "오류", message: "데이터를 불러올 수 없습니다.")
                }
                return
            }
            
            let convertedRates = result.rates.map { (key, value) in
                (country: key, rate: value)
            }
            
            DispatchQueue.main.async {
                self.exchangeRates = convertedRates
                self.exchangeRateTableView.reloadData()
            }
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
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
