//
//  CalculatorView.swift
//  ExchangeRateCalculator
//
//  Created by shinyoungkim on 4/17/25.
//

import UIKit

class CalculatorView: UIView {
    private let currencyCodeLabel: UILabel = {
        let label = UILabel()
        label.font = FontStyle.currencyCode
        return label
    }()
    private let countryNameLabel: UILabel = {
        let label = UILabel()
        label.font = FontStyle.countryName
        label.textColor = .gray
        return label
    }()
    private let amountTextField: UITextField = {
        let tf = UITextField()
        return tf
    }()
    private let convertButton: UIButton = {
        let button = UIButton()
        return button
    }()
    private let resultLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        
    }
}
