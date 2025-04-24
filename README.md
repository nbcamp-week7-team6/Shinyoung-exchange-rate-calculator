# 📱 환율 계산기 (ExchangeRateCalculator)

> 실시간 환율 조회 및 계산이 가능한 iOS 앱입니다.  
> 즐겨찾기 기능, 다크모드 대응, 앱 상태 복원 등 다양한 기능을 제공합니다.

---

## 🛠 주요 기능

### ✅ 환율 리스트
- 실시간 환율 API를 통해 데이터를 불러와 표시
- 통화 코드 및 국가명으로 검색 가능
- 환율 변화에 따라 상승 🔼 / 하락 🔽 여부 아이콘 표시
- 즐겨찾기(⭐️)한 통화는 리스트 상단에 고정되며, 알파벳순 정렬

### ✅ 환율 계산기
- 특정 통화를 선택하여 계산기 화면으로 이동
- 달러 기준으로 입력한 금액을 선택한 통화로 변환

### ✅ 앱 상태 저장 및 복원
- 마지막으로 본 화면(리스트 or 계산기)을 `CoreData`에 저장
- 앱 재실행 시 자동으로 해당 화면으로 복원

### ✅ 다크모드 지원
- Asset Catalog 및 시스템 색상 사용
- `BackgroundColor`, `TextColor`, `SecondaryTextColor`, `CellBackgroundColor` 등 다크/라이트 모드 대응

---

## 🧱 아키텍처: MVVM

이 앱은 **MVVM (Model-View-ViewModel)** 디자인 패턴으로 설계되어,
`ViewController`는 UI 이벤트를 ViewModel로 전달하고, ViewModel은 상태를 업데이트하여 View와 바인딩됩니다.

### 📌 핵심 흐름

```swift
// ViewModel 내
enum Action {
    case fetch
    case search(String)
    case selectItem(index: Int)
    case toggleFavorite(code: String)
}

struct State {
    var items = [ExchangeRateItem]()
}

enum ViewState {
    case success([ExchangeRateItem])
    case failure(message: String)
    case navigateToCalculator(selectedItem: ExchangeRateItem)
}

var action: ((Action) -> Void)?
private(set) var state = State()
var onStateChange: ((ViewState) -> Void)?
```

- `action`: View(ViewController) → ViewModel로 이벤트 전달
- `state`: 현재 데이터 상태
- `onStateChange`: ViewModel → View로 변경 사항을 알리는 클로저

### 💡 클로저 기반 바인딩 예시

```swift
private func bindViewModel() {
    viewModel.onStateChange = { [weak self] state in
        switch state {
        case .success(let items):
            self?.updateTable(with: items)
        case .failure(let message):
            self?.showAlert(message)
        case .navigateToCalculator(let item):
            self?.navigateToCalculatorScreen(with: item)
        }
    }
}
```

---

## 🗂 프로젝트 구조

```
ExchangeRateCalculator/
├── App/
│   ├── AppDelegate.swift
│   ├── Info.plist
│   ├── LaunchScreen.storyboard
│   └── SceneDelegate.swift
│
├── Controllers/
│   ├── CalculatorViewController.swift
│   └── MainViewController.swift
│
├── Extensions/
│   └── UIViewController+Alert.swift
│
├── Models/
│   ├── ExchangeRate.swift
│   ├── ExchangeRateItem.swift
│   └── CoreData/
│       ├── AppState+CoreDataClass.swift
│       ├── AppState+CoreDataProperties.swift
│       ├── CachedExchangeRate+CoreDataClass.swift
│       ├── CachedExchangeRate+CoreDataProperties.swift
│       ├── ExchangeRateCalculator.xcdatamodeld
│       ├── FavoriteCurrency+CoreDataClass.swift
│       └── FavoriteCurrency+CoreDataProperties.swift
│
├── Protocols/
│   ├── NetworkServiceProtocol.swift
│   └── ViewModelProtocol.swift
│
├── Resources/
│   └── Assets.xcassets
│
├── Services/
│   ├── CoreDataService.swift
│   ├── NetworkService.swift
│   └── Mock/
│       ├── mock_exchange_rate.json
│       └── MockNetworkService.swift
│
├── Utils/
│   └── Constants.swift
│
├── ViewModels/
│   ├── CalculatorViewModel.swift
│   └── ExchangeRateViewModel.swift
│
└── Views/
    ├── CalculatorView.swift
    ├── ExchangeRateTableView.swift
    └── ExchangeRateTableViewCell.swift

```

---

## 🔧 기술 스택

- **UIKit / SnapKit**  
- **MVVM 아키텍처**  
- **Core Data (앱 상태 및 즐겨찾기 캐싱)**  
- **URLSession (비동기 네트워크 통신)**  
- **Dark Mode 대응 (Asset Catalog + system color)**
- **Mock 기반 테스트 설계**
