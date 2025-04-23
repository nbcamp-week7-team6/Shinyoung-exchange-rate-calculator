//
//  ViewController.swift
//  ExchangeRateCalculator
//
//  Created by shinyoungkim on 4/16/25.
//

import UIKit
import SnapKit

final class MainViewController: UIViewController {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "환율 정보"
        label.font = FontStyle.titleLabel
        label.textColor = ColorStyle.text
        return label
    }()
    private let searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "통화 검색"
        return sb
    }()
    private let emptyStateLabel: UILabel = {
        let label = UILabel()
        label.text = "검색 결과 없음"
        label.textAlignment = .center
        label.font = FontStyle.HomeView.countryName
        label.textColor = ColorStyle.secondaryText
        return label
    }()
    private let exchangeRateTableView = ExchangeRateTableView()
    
    private let viewModel = ExchangeRateViewModel(networkService: MockNetworkService())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupSearchBar()
        setupTableView()
        setupConstraints()
        bindViewModel()
        viewModel.action?(.fetch)
        
        self.navigationItem.backButtonTitle = "환율 정보"
    }
    
    private func setupViews() {
        view.backgroundColor = UIColor(named: "BackgroundColor")
        [
            titleLabel,
            searchBar,
            exchangeRateTableView
        ].forEach { view.addSubview($0) }
    }
    
    private func setupSearchBar() {
        searchBar.delegate = self
    }
    
    private func setupTableView() {
        exchangeRateTableView.delegate = self
        exchangeRateTableView.dataSource = self
        exchangeRateTableView.rowHeight = 60
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.equalToSuperview().inset(16)
        }
        searchBar.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview()
        }
        exchangeRateTableView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func bindViewModel() {
        viewModel.onStateChange = { [weak self] state in
            switch state {
            case .success(let items):
                self?.updateEmptyState(items)
                self?.exchangeRateTableView.reloadData()
            case .failure(let message):
                self?.showAlert(title: "오류", message: message)
            case .navigateToCalculator(let selectedItem):
                let calculatorVC = CalculatorViewController(item: selectedItem)
                self?.navigationController?.pushViewController(calculatorVC, animated: true)
            }
        }
    }
    
    private func updateEmptyState(_ items: [ExchangeRateItem]) {
        if items.isEmpty {
            exchangeRateTableView.backgroundView = emptyStateLabel
        } else {
            exchangeRateTableView.backgroundView = nil
        }
    }
}

extension MainViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.action?(.search(searchText))
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.state.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = exchangeRateTableView.dequeueReusableCell(withIdentifier: CellIdentifier.exchangeRate) as? ExchangeRateTableViewCell else {
            return UITableViewCell()
        }
        
        let item = viewModel.state.items[indexPath.row]
        let isFavorite = Set(CoreDataService.shared.fetchFavorites()).contains(item.code)
        
        cell.delegate = self
        cell.configure(with: item, isFavorite: isFavorite)
        
        return cell
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        exchangeRateTableView.deselectRow(at: indexPath, animated: true)
        viewModel.action?(.selectItem(index: indexPath.row))
    }
}

extension MainViewController: ExchangeRateTableViewCellDelegate {
    func didTapFavoriteButton(in cell: ExchangeRateTableViewCell) {
        guard let indexPath = exchangeRateTableView.indexPath(for: cell) else { return }
        let item = viewModel.state.items[indexPath.row]
        viewModel.action?(.toggleFavorite(code: item.code))
    }
}
