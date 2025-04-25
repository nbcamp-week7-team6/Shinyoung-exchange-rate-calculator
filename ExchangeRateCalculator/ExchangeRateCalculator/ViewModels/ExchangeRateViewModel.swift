//
//  ExchangeRateViewModel.swift
//  ExchangeRateCalculator
//
//  Created by shinyoungkim on 4/21/25.
//

import Foundation

/// 환율 데이터를 처리하고 View와 상태를 연결하는 뷰모델
final class ExchangeRateViewModel: ViewModelProtocol {
    /// View에서 발생하는 사용자 액션 정의
    enum Action {
        // 환율 데이터 요청
        case fetch
        // 검색어로 환율 필터링
        case search(String)
        // 셀 선택
        case selectItem(index: Int)
        // 즐겨찾기 토글
        case toggleFavorite(code: String)
        // 현재 앱 상태 저장
        case saveAppState(screen: String, code: String?)
    }
    
    /// 내부 상태값
    struct State {
        var items = [ExchangeRateItem]()
    }
    
    /// View로 전달되는 결과 상태 (UI 변경 유도)
    enum ViewState {
        // 리스트 성공
        case success([ExchangeRateItem])
        // 실패 시 메시지 표시
        case failure(message: String)
        // 계산기 화면으로 이동
        case navigateToCalculator(selectedItem: ExchangeRateItem)
    }
    
    // 네트워크 서비스 (실제 or Mock 주입 가능)
    private let networkService: NetworkServiceProtocol
    // 전체 환율 목록
    private var allExchangeRates = [ExchangeRateItem]()
    
    /// 외부에서 액션을 전달받는 클로저
    var action: ((Action) -> Void)?
    /// 읽기 전용 상태
    private(set) var state = State()
    /// ViewController에서 결과를 처리하기 위한 클로저
    var onStateChange: ((ViewState) -> Void)?
    
    /// 초기화 시 networkService를 주입받고 액션을 바인딩
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
        bind()
    }
    
    /// 사용자 액션을 처리할 클로저 바인딩
    private func bind() {
        action = { [weak self] action in
            switch action {
            case .fetch:
                self?.fetchExchangeRate()
            case .search(let keyword):
                self?.filterExchangeRates(with: keyword)
            case .selectItem(index: let index):
                self?.handleSelection(at: index)
            case .toggleFavorite(let code):
                self?.toggleFavorite(code: code)
            case .saveAppState(let screen, let code):
                CoreDataService.shared.saveAppState(screen: screen, code: code)
            }
        }
    }
    
    /// 최신 환율 데이터를 API로부터 받아와 상태 업데이트
    private func fetchExchangeRate() {
        guard let url = URL(string: API.latestRates) else { return }
        
        networkService.fetchData(url: url) { [weak self] (result: ExchangeRateResult?) in
            guard let self else { return }
            
            guard let result else {
                DispatchQueue.main.async {
                    self.onStateChange?(.failure(message: "데이터를 불러올 수 없습니다."))
                }
                return
            }
            
            
            
            
            
            
            
            // 즐겨찾기 기준으로 정렬
            let sorted = self.applyFavoriteSorting(to: mapped)
            
            self.allExchangeRates = sorted
            self.state.items = sorted
            
            // View 업데이트
            DispatchQueue.main.async {
                self.onStateChange?(.success(sorted))
            }
        }
    }
    
    /// 키워드에 따라 환율 데이터를 필터링 후 상태 갱신
    private func filterExchangeRates(with keyword: String) {
        let filteredExchangeRates: [ExchangeRateItem]
        
        if keyword.isEmpty {
            filteredExchangeRates = allExchangeRates
        } else {
            filteredExchangeRates = allExchangeRates.filter {
                $0.code.lowercased().contains(keyword.lowercased()) ||
                $0.countryName.contains(keyword)
            }
        }
        
        let sorted = applyFavoriteSorting(to: filteredExchangeRates)
        self.state.items = sorted
        
        DispatchQueue.main.async {
            self.onStateChange?(.success(sorted))
        }
    }
    
    /// 셀 선택 시 계산기 화면으로 이동
    private func handleSelection(at index: Int) {
        guard index >= 0, index < state.items.count else { return }
        
        let selectedItem = state.items[index]
        onStateChange?(.navigateToCalculator(selectedItem: selectedItem))
    }
    
    /// 즐겨찾기 토글 (추가 또는 제거 후 리스트 갱신)
    private func toggleFavorite(code: String) {
        let isFavorite = CoreDataService.shared.fetchFavorites().contains(code)
        
        if isFavorite {
            CoreDataService.shared.removeFavorite(code: code)
        } else {
            CoreDataService.shared.addFavorite(code: code)
        }
        
        filterExchangeRates(with: "")
    }
    
    /// 즐겨찾기 여부에 따라 정렬된 리스트 반환
    private func applyFavoriteSorting(to items: [ExchangeRateItem]) -> [ExchangeRateItem] {
        let favorites = Set(CoreDataService.shared.fetchFavorites())
        
        return items.sorted {
            if favorites.contains($0.code) == favorites.contains($1.code) {
                // 즐겨찾기 내부는 알파벳 순
                return $0.code < $1.code
            }
            // 즐겨찾기 먼저 정렬
            return favorites.contains($0.code)
        }
    }
}
