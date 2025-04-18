//
//  CalculatorView.swift
//  ExchangeRateCalculator
//
//  Created by shinyoungkim on 4/17/25.
//

import UIKit
import SnapKit

class CalculatorView: UIView {
    private let currencyCodeLabel: UILabel = {
        let label = UILabel()
        label.font = FontStyle.Calculator.currencyCode
        return label
    }()
    private let countryNameLabel: UILabel = {
        let label = UILabel()
        label.font = FontStyle.Calculator.countryName
        label.textColor = .gray
        return label
    }()
    private let currencyInfoStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 4
        sv.alignment = .center
        return sv
    }()
    private let amountTextField: UITextField = {
        let tf = UITextField()
        tf.borderStyle = .roundedRect
        tf.keyboardType = .decimalPad
        tf.textAlignment = .center
        tf.placeholder = "금액을 입력하세요."
        return tf
    }()
    let convertButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = FontStyle.Calculator.convertButton
        button.setTitle("환율 계산", for: .normal)
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        return button
    }()
    private let resultLabel: UILabel = {
        let label = UILabel()
        label.font = FontStyle.Calculator.resultLabel
        label.textAlignment = .center
        label.text = "계산 결과가 여기에 표시됩니다."
        label.numberOfLines = 0
        return label
    }()
    
    var inputAmount: String? {
        return amountTextField.text
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        [
            currencyCodeLabel,
            countryNameLabel,
        ].forEach { currencyInfoStackView.addArrangedSubview($0) }
        
        [
            currencyInfoStackView,
            amountTextField,
            convertButton,
            resultLabel
        ].forEach { addSubview($0) }
    }
    
    private func setupConstraints() {
        currencyInfoStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(32)
            $0.centerX.equalToSuperview()
        }
        
        amountTextField.snp.makeConstraints {
            $0.top.equalTo(currencyInfoStackView.snp.bottom).offset(32)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(44)
        }
        
        convertButton.snp.makeConstraints {
            $0.top.equalTo(amountTextField.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(44)
        }
        
        resultLabel.snp.makeConstraints {
            $0.top.equalTo(convertButton.snp.bottom).offset(32)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
    }
    
    func configure(with item: ExchangeRateItem) {
        currencyCodeLabel.text = item.code
        countryNameLabel.text = item.countryName
    }
    
    func showResult(_ text: String) {
        resultLabel.text = text
    }
}
