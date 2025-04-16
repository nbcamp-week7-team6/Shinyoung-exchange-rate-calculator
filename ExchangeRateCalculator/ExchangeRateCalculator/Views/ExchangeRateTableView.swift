//
//  ExchangeRateTableView.swift
//  ExchangeRateCalculator
//
//  Created by shinyoungkim on 4/16/25.
//

import UIKit

final class ExchangeRateTableView: UITableView {

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        self.register(ExchangeRateTableViewCell.self, forCellReuseIdentifier: CellIdentifier.exchangeRate)
    }
}
