//
//  CalculatorViewController.swift
//  ExchangeRateCalculator
//
//  Created by shinyoungkim on 4/17/25.
//

import UIKit
import SnapKit

/// 사용자가 환율을 입력하여 변환할 수 있는 계산기 화면입니다.
class CalculatorViewController: UIViewController {
    /// 환율 계산 UI를 포함한 커스텀 뷰
    private let calculatorView = CalculatorView()
    
    /// 상단 타이틀 라벨
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "환율 계산기"
        label.font = FontStyle.titleLabel
        label.textColor = ColorStyle.text
        return label
    }()
    
    /// 환율 변환 로직을 처리하는 뷰모델
    private let viewModel: CalculatorViewModel
    
    /// 주어진 환율 아이템으로 계산기 화면 초기화
    init(
        item: ExchangeRateItem,
        convertCurrencyUseCase: ConvertCurrencyUseCase = DefaultConvertCurrencyUseCase()
    ) {
        self.viewModel = CalculatorViewModel(
            exchangeRateItem: item,
            convertCurrencyUseCase: convertCurrencyUseCase
        )
        super.init(nibName: nil, bundle: nil)
    }
    
    /// 스토리보드 초기화는 지원하지 않음
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("#### CalculatorViewController deinit")
    }
    
    // MARK: - 생명주기

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupConstraints()
        calculatorView.configure(with: viewModel.exchangeRateItem)
        // 변환 버튼에 이벤트 연결
        calculatorView.convertButton.addTarget(
            self,
            action: #selector(convertButtonTapped),
            for: .touchUpInside
        )
        bindViewModel()
    }
    
    // MARK: - UI 세팅
    
    /// 화면에 UI 요소 추가 및 배경색 설정
    private func setupViews() {
        view.backgroundColor = UIColor(named: "BackgroundColor")
        [
            titleLabel,
            calculatorView
        ].forEach { view.addSubview($0) }
    }
    
    /// SnapKit을 사용하여 오토레이아웃 설정
    private func setupConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.equalToSuperview().inset(24)
        }
        
        calculatorView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    /// 변환 버튼 탭 시 호출되는 메서드
    @objc private func convertButtonTapped() {
        let input = calculatorView.inputAmount ?? ""
        viewModel.action?(.convert(input: input))
    }
    
    // MARK: - ViewModel 바인딩
    
    /// 뷰모델과 UI 바인딩하여 상태 변화에 따라 화면을 갱신합니다.
    private func bindViewModel() {
        viewModel.onStateChange = { [weak self] state in
            switch state {
            case .showResult(let resultText):
                self?.calculatorView.showResult(resultText)
            case .showError(let message):
                self?.showAlert(title: "오류", message: message)
            }
        }
    }
}
