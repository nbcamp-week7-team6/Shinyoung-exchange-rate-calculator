//
//  ExchangeRateTableView.swift
//  ExchangeRateCalculator
//
//  Created by shinyoungkim on 4/16/25.
//

import UIKit

/// 환율 정보를 표시하는 테이블 뷰
/// - 커스텀 셀을 등록하고 기본 스타일을 구성
final class ExchangeRateTableView: UITableView {    
    /// 코드 기반 초기화 시 호출되는 생성자
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        setup()
    }
    
    /// 스토리보드 초기화는 지원하지 않음
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 셀 등록 등 테이블 뷰 초기 설정
    private func setup() {
        // 커스텀 셀 등록
        self.register(ExchangeRateTableViewCell.self, forCellReuseIdentifier: CellIdentifier.exchangeRate)
    }
}
