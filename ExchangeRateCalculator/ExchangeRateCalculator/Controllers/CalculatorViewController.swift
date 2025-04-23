//
//  CalculatorViewController.swift
//  ExchangeRateCalculator
//
//  Created by shinyoungkim on 4/17/25.
//

import UIKit
import SnapKit

class CalculatorViewController: UIViewController {
    private let calculatorView = CalculatorView()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "환율 계산기"
        label.font = FontStyle.titleLabel
        label.textColor = ColorStyle.text
        return label
    }()
    
    private let viewModel: CalculatorViewModel
    
    init(item: ExchangeRateItem) {
        self.viewModel = CalculatorViewModel(exchangeRateItem: item)
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupConstraints()
        calculatorView.configure(with: viewModel.exchangeRateItem)
        calculatorView.convertButton.addTarget(
            self,
            action: #selector(convertButtonTapped),
            for: .touchUpInside
        )
        bindViewModel()
    }
    
    private func setupViews() {
        view.backgroundColor = UIColor(named: "BackgroundColor")
        [
            titleLabel,
            calculatorView
        ].forEach { view.addSubview($0) }
    }
    
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
    
    @objc private func convertButtonTapped() {
        let input = calculatorView.inputAmount ?? ""
        viewModel.action?(.convert(input: input))
    }
    
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
