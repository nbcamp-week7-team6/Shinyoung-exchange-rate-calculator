//
//  ExchangeRateTableViewCell.swift
//  ExchangeRateCalculator
//
//  Created by shinyoungkim on 4/16/25.
//

import UIKit
import SnapKit

protocol ExchangeRateTableViewCellDelegate: AnyObject {
    func didTapFavoriteButton(in cell: ExchangeRateTableViewCell)
}

class ExchangeRateTableViewCell: UITableViewCell {
    weak var delegate: ExchangeRateTableViewCellDelegate?
    
    private let currencyCodeLabel: UILabel = {
        let label = UILabel()
        label.font = FontStyle.HomeView.currencyCode
        return label
    }()
    
    private let countryNameLabel: UILabel = {
        let label = UILabel()
        label.font = FontStyle.HomeView.countryName
        label.textColor = .gray
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
        label.font = FontStyle.HomeView.rate
        label.textAlignment = .right
        return label
    }()
    
    private let favoriteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "star.png"), for: .normal)
        button.setImage(UIImage(named: "star.fill.png"), for: .selected)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
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
            countryNameLabel
        ].forEach { currencyInfoStackView.addArrangedSubview($0) }
        
        [
            currencyInfoStackView,
            exchangeRateLabel,
            favoriteButton
        ].forEach { contentView.addSubview($0) }
        
        favoriteButton.addTarget(self, action: #selector(favoriteTapped), for: .touchUpInside)
    }
    
    private func setupConstraints() {
        currencyInfoStackView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }
        
        exchangeRateLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(currencyInfoStackView.snp.trailing).offset(16)
            $0.width.equalTo(120)
        }
        
        favoriteButton.snp.makeConstraints {
            $0.leading.equalTo(exchangeRateLabel.snp.trailing).offset(8)
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(24)
        }
    }
    
    func configure(with item: ExchangeRateItem, isFavorite: Bool) {
        currencyCodeLabel.text = item.code
        countryNameLabel.text = item.countryName
        exchangeRateLabel.text = String(format: "%.4f", item.rate)
        favoriteButton.isSelected = isFavorite
    }
    
    @objc private func favoriteTapped() {
        delegate?.didTapFavoriteButton(in: self)
    }
}
