//
//  SceneDelegate.swift
//  ExchangeRateCalculator
//
//  Created by shinyoungkim on 4/24/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        
        CoreDataService.shared.configure(context: (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext)
        
        let mainVC = MainViewController()
        
        let backItem = UIBarButtonItem()
        backItem.title = "환율 정보"
        mainVC.navigationItem.backBarButtonItem = backItem
        
        let navController = UINavigationController(rootViewController: mainVC)
        
        if let state = CoreDataService.shared.fetchAppState(),
           state.screen == "calculator",
           let code = state.code {
            
            let item = ExchangeRateItem(
                code: code,
                countryName: currencyCountryMap[code] ?? "",
                rate: CoreDataService.shared.fetchCachedRates()[code] ?? 0.0
            )
            let calculatorVC = CalculatorViewController(item: item)
            
            navController.pushViewController(calculatorVC, animated: false)
        }
        
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = navController
            self.window = window
            window.makeKeyAndVisible()
        }
    }
}
