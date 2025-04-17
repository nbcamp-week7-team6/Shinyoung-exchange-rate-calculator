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
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(calculatorView)
    }
    
    private func setupConstraints() {
        calculatorView.snp.makeConstraints {
            $0.top.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
    }
}
