//
//  CalculatorView.swift
//  ExchangeRateCalculator
//
//  Created by shinyoungkim on 4/17/25.
//

import UIKit
import SnapKit

/// 환율 계산기 화면의 UI를 구성하는 뷰
class CalculatorView: UIView {
    
    // MARK: - UI Components
        
    /// 통화 코드 레이블 (예: USD)
    private let currencyCodeLabel: UILabel = {
        let label = UILabel()
        label.font = FontStyle.CalculatorView.currencyCode
        label.textColor = ColorStyle.text
        return label
    }()
    
    /// 국가명 레이블 (예: 미국)
    private let countryNameLabel: UILabel = {
        let label = UILabel()
        label.font = FontStyle.CalculatorView.countryName
        label.textColor = ColorStyle.secondaryText
        return label
    }()
    
    /// 통화 코드와 국가명을 담는 수직 스택뷰
    private let currencyInfoStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 4
        sv.alignment = .center
        return sv
    }()
    
    /// 금액을 입력하는 텍스트 필드
    private let amountTextField: UITextField = {
        let tf = UITextField()
        tf.borderStyle = .roundedRect
        tf.keyboardType = .decimalPad
        tf.textAlignment = .center
        tf.placeholder = "금액을 입력하세요."
        return tf
    }()
    
    /// 환율 계산 버튼
    let convertButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = ColorStyle.buttonBackground
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = FontStyle.CalculatorView.convertButton
        button.setTitle("환율 계산", for: .normal)
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        return button
    }()
    
    /// 계산 결과를 출력하는 레이블
    private let resultLabel: UILabel = {
        let label = UILabel()
        label.font = FontStyle.CalculatorView.resultLabel
        label.textColor = ColorStyle.text
        label.textAlignment = .center
        label.text = "계산 결과가 여기에 표시됩니다."
        label.numberOfLines = 0
        return label
    }()
    
    /// 입력된 금액을 가져오는 계산 속성
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
    
    // MARK: - UI 세팅
        
    /// 서브뷰들을 추가
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
    
    /// SnapKit을 이용한 오토레이아웃 설정
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
    
    /// 뷰에 통화 정보를 적용하는 메서드
    /// - Parameter item: 환율 정보 모델
    func configure(with item: ExchangeRateItem) {
        currencyCodeLabel.text = item.code
        countryNameLabel.text = item.countryName
    }
    
    /// 계산 결과 텍스트를 출력하는 메서드
    /// - Parameter text: 계산 결과 문자열
    func showResult(_ text: String) {
        resultLabel.text = text
    }
}
