//
//  CalculatorViewController.swift
//  ExchangeRateCalculator
//
//  Created by shinyoungkim on 4/17/25.
//

import UIKit

class CalculatorViewController: UIViewController {
    private let code: String
    private let countryName: String
    private let rate: Double
    
    init(code: String, countryName: String, rate: Double) {
        self.code = code
        self.countryName = countryName
        self.rate = rate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

}
