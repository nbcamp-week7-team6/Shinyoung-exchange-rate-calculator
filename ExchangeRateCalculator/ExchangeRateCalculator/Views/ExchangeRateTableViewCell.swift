//
//  ExchangeRateTableViewCell.swift
//  ExchangeRateCalculator
//
//  Created by shinyoungkim on 4/16/25.
//

import UIKit
import SnapKit

/// 셀 내부에서 즐겨찾기 버튼이 눌렸을 때 이벤트를 전달하는 델리게이트 프로토콜
protocol ExchangeRateTableViewCellDelegate: AnyObject {
    func didTapFavoriteButton(in cell: ExchangeRateTableViewCell)
}

/// 환율 정보를 보여주는 커스텀 테이블 뷰 셀
class ExchangeRateTableViewCell: UITableViewCell {
    /// 델리게이트를 통해 즐겨찾기 버튼 클릭 이벤트 전달
    weak var delegate: ExchangeRateTableViewCellDelegate?
    
    // MARK: - UI Components
    
    /// 통화 코드 레이블 (예: USD)
    private let currencyCodeLabel: UILabel = {
        let label = UILabel()
        label.font = FontStyle.HomeView.currencyCode
        label.textColor = ColorStyle.text
        return label
    }()
    
    /// 국가명 레이블 (예: 미국)
    private let countryNameLabel: UILabel = {
        let label = UILabel()
        label.font = FontStyle.HomeView.countryName
        label.textColor = ColorStyle.secondaryText
        return label
    }()
    
    /// 통화 코드와 국가명을 담는 수직 스택뷰
    private let currencyInfoStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 4
        return sv
    }()
    
    /// 환율 값을 표시하는 레이블
    private let exchangeRateLabel: UILabel = {
        let label = UILabel()
        label.font = FontStyle.HomeView.rate
        label.textColor = ColorStyle.text
        label.textAlignment = .right
        return label
    }()
    
    /// 환율 변화 상태를 나타내는 아이콘
    private let changeIconLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    /// 즐겨찾기 버튼
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
    
    // MARK: - UI 세팅
        
    /// UI 요소를 뷰에 추가하고 즐겨찾기 버튼에 액션 연결
    private func setupViews() {
        [
            currencyCodeLabel,
            countryNameLabel
        ].forEach { currencyInfoStackView.addArrangedSubview($0) }
        
        [
            currencyInfoStackView,
            exchangeRateLabel,
            changeIconLabel,
            favoriteButton
        ].forEach { contentView.addSubview($0) }
        
        favoriteButton.addTarget(self, action: #selector(favoriteTapped), for: .touchUpInside)
    }
    
    /// SnapKit을 사용한 오토레이아웃 설정
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
        
        changeIconLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(exchangeRateLabel.snp.trailing).offset(8)
            $0.width.height.equalTo(24)
        }
        
        favoriteButton.snp.makeConstraints {
            $0.leading.equalTo(changeIconLabel.snp.trailing).offset(8)
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(24)
        }
    }
    
    // MARK: - Configuration
    
    /// 셀의 데이터 설정
    /// - Parameters:
    ///   - item: 환율 정보 모델
    ///   - isFavorite: 즐겨찾기 여부
    func configure(with item: ExchangeRateItem, isFavorite: Bool) {
        currencyCodeLabel.text = item.code
        countryNameLabel.text = item.countryName
        exchangeRateLabel.text = String(format: "%.4f", item.rate)
        favoriteButton.isSelected = isFavorite
        
        switch item.change {
        case .up:
            changeIconLabel.text = "🔼"
        case .down:
            changeIconLabel.text = "🔽"
        case .same, .unknown:
            changeIconLabel.text = nil
        }
    }
    
    // MARK: - Actions
        
    /// 즐겨찾기 버튼이 탭되었을 때 델리게이트를 통해 이벤트 전달    
    @objc private func favoriteTapped() {
        delegate?.didTapFavoriteButton(in: self)
    }
}
