//
//  ExchangeRateTableViewCell.swift
//  ExchangeRateCalculator
//
//  Created by shinyoungkim on 4/16/25.
//

import UIKit
import SnapKit

class ExchangeRateTableViewCell: UITableViewCell {
    private let currencyCodeLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let countryNameLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let currencyInfoStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 4
        return sv
    }()
    
    private let exchangeRateLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        [
            currencyCodeLabel,
            countryNameLabel
        ].forEach {
            currencyInfoStackView.addArrangedSubview($0)
        }
        contentView.addSubview(currencyInfoStackView)
        contentView.addSubview(exchangeRateLabel)
    }
    
    private func setupConstraints() {
        currencyInfoStackView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }
        
        exchangeRateLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }
    }
    
    func configure(code: String, countryName: String, rate: Double) {
        currencyCodeLabel.text = code
        countryNameLabel.text = countryName
        exchangeRateLabel.text = String(format: "%.4f", rate)
    }
}
