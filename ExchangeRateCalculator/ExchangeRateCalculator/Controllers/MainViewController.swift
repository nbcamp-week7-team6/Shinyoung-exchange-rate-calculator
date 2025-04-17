//
//  ViewController.swift
//  ExchangeRateCalculator
//
//  Created by shinyoungkim on 4/16/25.
//

import UIKit
import SnapKit

final class MainViewController: UIViewController {
    private let searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "통화 검색"
        return sb
    }()
    private let emptyStateLabel: UILabel = {
        let label = UILabel()
        label.text = "검색 결과 없음"
        label.textAlignment = .center
        label.font = FontStyle.countryName
        label.textColor = .gray
        return label
    }()
    private let exchangeRateTableView = ExchangeRateTableView()
    
    private let exchangeRateService = ExchangeRateService()
    
    private var allExchangeRates = [ExchangeRateItem]()
    private var filteredExchangeRates = [ExchangeRateItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupSearchBar()
        setupTableView()
        setupConstraints()
        fetchExchangeRateData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        
        view.addSubview(searchBar)
        view.addSubview(exchangeRateTableView)
    }
    
    private func setupSearchBar() {
        searchBar.delegate = self
    }
    
    private func setupTableView() {
        exchangeRateTableView.dataSource = self
        exchangeRateTableView.rowHeight = 60
    }
    
    private func setupConstraints() {
        searchBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        exchangeRateTableView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
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
            
            let mapped = result.items
            
            DispatchQueue.main.async {
                // allExchangeRates의 목적: 검색어를 지웠을 때 원래 데이터로 돌아가기 위함
                self.allExchangeRates = mapped
                self.filteredExchangeRates = mapped
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

extension MainViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredExchangeRates = allExchangeRates
        } else {
            filteredExchangeRates = allExchangeRates.filter {
                $0.code.lowercased().contains(searchText.lowercased()) ||
                $0.countryName.contains(searchText)
            }
        }
        
        exchangeRateTableView.reloadData()
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredExchangeRates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = exchangeRateTableView.dequeueReusableCell(withIdentifier: CellIdentifier.exchangeRate) as? ExchangeRateTableViewCell else {
            return UITableViewCell()
        }
        
        let item = filteredExchangeRates[indexPath.row]
        cell.configure(code: item.code, countryName: item.countryName, rate: item.rate)
        
        return cell
    }
}
