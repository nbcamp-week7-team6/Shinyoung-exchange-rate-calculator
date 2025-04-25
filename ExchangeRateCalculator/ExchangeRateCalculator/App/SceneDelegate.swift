//
//  SceneDelegate.swift
//  ExchangeRateCalculator
//
//  Created by shinyoungkim on 4/24/25.
//

import UIKit

/// SceneDelegate는 앱의 UI 생명주기를 관리합니다.
/// 앱이 실행될 때 첫 화면 설정 및 상태 복원 로직을 포함합니다.
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    /// 앱의 메인 윈도우
    var window: UIWindow?
    
    /// 씬이 연결될 때 호출되는 메서드입니다.
    /// CoreData를 초기화하고, 마지막으로 저장된 화면 상태를 기반으로 적절한 ViewController를 구성합니다.
    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        
        // CoreDataService에 context 주입
        CoreDataService.shared.configure(context: (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext)
        
        let viewModel = ExchangeRateViewModel(
            fetchExchangeRatesUseCase: DefaultFetchExchangeRatesUseCase(
                repository: DefaultExchangeRateRepository()
            ),
            toggleFavoriteUseCase: DefaultToggleFavoriteCurrencyUseCase(),
            fetchFavoritesUseCase: DefaultFetchFavoriteCurrencyCodesUseCase(),
            saveAppStateUseCase: DefaultSaveAppStateUseCase(),
            updateExchangeRateCacheUseCase: DefaultUpdateExchangeRateCacheUseCase())
        
        // 메인 화면 (환율 목록 화면) 생성
        let mainVC = MainViewController(viewModel: viewModel)
        
        // Calculator 화면에서 뒤로가기 버튼 제목을 "환율 정보"로 표시
        let backItem = UIBarButtonItem()
        backItem.title = "환율 정보"
        mainVC.navigationItem.backBarButtonItem = backItem
        
        // 메인 화면을 내비게이션 컨트롤러로 감싸기
        let navController = UINavigationController(rootViewController: mainVC)
        
        // 저장된 화면 상태를 불러와 calculator 화면이 마지막이면 해당 화면으로 복원
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
        
        // 윈도우 설정
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = navController
            self.window = window
            window.makeKeyAndVisible()
        }
    }
}
