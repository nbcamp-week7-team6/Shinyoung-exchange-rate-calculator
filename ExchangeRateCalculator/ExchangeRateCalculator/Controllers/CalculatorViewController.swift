//
//  CalculatorViewController.swift
//  ExchangeRateCalculator
//
//  Created by shinyoungkim on 4/17/25.
//

import UIKit
import SnapKit

class CalculatorViewController: UIViewController {
    private let item: ExchangeRateItem
    
    private let calculatorView = CalculatorView()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "환율 계산기"
        label.font = FontStyle.titleLabel
        return label
    }()
    
    init(item: ExchangeRateItem) {
        self.item = item
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupConstraints()
        calculatorView.configure(with: item)
        calculatorView.convertButton.addTarget(
            self,
            action: #selector(convertButtonTapped),
            for: .touchUpInside
        )
    }
    
    private func setupViews() {
        view.backgroundColor = .white
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
        print("환율 계산")
    }
}
