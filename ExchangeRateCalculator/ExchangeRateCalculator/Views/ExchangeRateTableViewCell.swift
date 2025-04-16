//
//  ExchangeRateTableViewCell.swift
//  ExchangeRateCalculator
//
//  Created by shinyoungkim on 4/16/25.
//

import UIKit
import SnapKit

class ExchangeRateTableViewCell: UITableViewCell {
    private let countryLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let rateLabel: UILabel = {
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
        contentView.addSubview(countryLabel)
        contentView.addSubview(rateLabel)
    }
    
    private func setupConstraints() {
        countryLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }
        
        rateLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }
    }
    
    func configure(country: String, rate: Double) {
        countryLabel.text = country
        rateLabel.text = String(format: "%.4f", rate)
    }
}
