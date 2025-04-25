//
//  ViewController.swift
//  ExchangeRateCalculator
//
//  Created by shinyoungkim on 4/16/25.
//

import UIKit
import SnapKit

/// 환율 목록을 보여주는 메인 화면입니다.
/// 검색 기능, 즐겨찾기 기능, 데이터 로딩, 계산기 화면 전환 기능을 포함합니다.
final class MainViewController: UIViewController {
    // MARK: - UI 요소
    
    /// 상단 타이틀 라벨 ("환율 정보")
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "환율 정보"
        label.font = FontStyle.titleLabel
        label.textColor = ColorStyle.text
        return label
    }()
    /// 통화 검색용 서치바
    private let searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "통화 검색"
        return sb
    }()
    /// 검색 결과가 없을 때 표시되는 라벨
    private let emptyStateLabel: UILabel = {
        let label = UILabel()
        label.text = "검색 결과 없음"
        label.textAlignment = .center
        label.font = FontStyle.HomeView.countryName
        label.textColor = ColorStyle.secondaryText
        return label
    }()
    /// 환율 정보를 보여줄 테이블뷰
    private let exchangeRateTableView = ExchangeRateTableView()
    
    /// 환율 목록을 관리하는 뷰모델
    private let viewModel: ExchangeRateViewModel
    
    init(viewModel: ExchangeRateViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // 현재 화면 상태 저장 (list 상태)
        viewModel.action?(.saveAppState(screen: "list", code: nil))
    }
    
    // MARK: - UI 세팅

    /// 뷰 계층 설정 및 배경색 적용
    private func setupViews() {
        view.backgroundColor = UIColor(named: "BackgroundColor")
        [
            titleLabel,
            searchBar,
            exchangeRateTableView
        ].forEach { view.addSubview($0) }
    }
    
    /// 서치바 델리게이트 연결
    private func setupSearchBar() {
        searchBar.delegate = self
    }
    
    /// 테이블뷰 델리게이트, 데이터소스 연결
    private func setupTableView() {
        exchangeRateTableView.delegate = self
        exchangeRateTableView.dataSource = self
        exchangeRateTableView.rowHeight = 60
    }
    
    /// SnapKit을 이용한 오토레이아웃 설정
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
    
    // MARK: - ViewModel 바인딩

    /// 뷰모델과 UI 바인딩하여 상태 변화에 따라 화면을 갱신합니다.
    private func bindViewModel() {
        viewModel.onStateChange = { [weak self] state in
            switch state {
            case .success(let items):
                self?.updateEmptyState(items)
                self?.exchangeRateTableView.reloadData()
            case .failure(let message):
                self?.showAlert(title: "오류", message: message)
            case .navigateToCalculator(let selectedItem):
                self?.viewModel.action?(.saveAppState(screen: "calculator", code: selectedItem.code))
                let calculatorVC = CalculatorViewController(item: selectedItem)
                self?.navigationController?.pushViewController(calculatorVC, animated: true)
            }
        }
    }
    
    /// 검색 결과가 비었을 때, 안내 라벨을 보여줍니다.
    private func updateEmptyState(_ items: [ExchangeRateItem]) {
        if items.isEmpty {
            exchangeRateTableView.backgroundView = emptyStateLabel
        } else {
            exchangeRateTableView.backgroundView = nil
        }
    }
}

// MARK: - UISearchBarDelegate

extension MainViewController: UISearchBarDelegate {
    /// 서치바에 입력된 텍스트가 변경될 때 호출됩니다.
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.action?(.search(searchText))
    }
}

// MARK: - UITableViewDataSource

extension MainViewController: UITableViewDataSource {
    /// 테이블 뷰 셀 개수 반환
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.state.items.count
    }
    
    /// 각 셀에 데이터 바인딩
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = exchangeRateTableView.dequeueReusableCell(withIdentifier: CellIdentifier.exchangeRate) as? ExchangeRateTableViewCell else {
            return UITableViewCell()
        }
        
        let item = viewModel.state.items[indexPath.row]
        let isFavorite = viewModel.isFavorite(code: item.code)
        
        cell.delegate = self
        cell.configure(with: item, isFavorite: isFavorite)
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension MainViewController: UITableViewDelegate {
    /// 셀을 선택했을 때 Calculator 화면으로 이동
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        exchangeRateTableView.deselectRow(at: indexPath, animated: true)
        viewModel.action?(.selectItem(index: indexPath.row))
    }
}

// MARK: - ExchangeRateTableViewCellDelegate

extension MainViewController: ExchangeRateTableViewCellDelegate {
    /// 즐겨찾기 버튼 터치 이벤트 처리
    func didTapFavoriteButton(in cell: ExchangeRateTableViewCell) {
        guard let indexPath = exchangeRateTableView.indexPath(for: cell) else { return }
        let item = viewModel.state.items[indexPath.row]
        viewModel.action?(.toggleFavorite(code: item.code))
    }
}
