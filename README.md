# WHAAT: Auto Translate 🔠

<img src="https://hackmd.io/_uploads/rkGEOs9-T.png" width="300"><br><BR>


## 소개
- 카메라가 비춘 글자를 실시간으로 번역해주는 앱
- iOS 16 이상의 환경에서 사용 가능합니다
- 프로젝트 기간 : 23/10/09~23/10/17

> ⚠️ **주의사항**
> 
> API 활용을 위해서 SecretKey.plist 파일 생성이 필요합니다.
> plist에 들어가는 내용은 아래 두 가지입니다.
> - PapagoClientSecret : Naver Developer의 Secret Key(String)
> - PapagoClientId : Naver Developer의 Client ID(String)

</br>

## 목차
1. 👩‍💻 [팀원 소개](#1.)
2. 📅 [타임 라인](#2.)
3. 🛠️ [활용 기술](#3.)
4. 📊 [시각화 구조](#4.)
5. 📱 [실행 화면](#5. )
6. 📌 [핵심 경험](#6.)
7. 🧨 [트러블 슈팅](#7.)
8. 📚 [참고 자료](#8.)

</br>

<a id="1."></a></br>
## 👩‍💻 팀원 소개
|<Img src="https://hackmd.io/_uploads/rk62zRiun.png" width="200">|
|:-:|
|[**maxhyunm**](https://github.com/maxhyunm)<br>(minhmin219@gmail.com)|

<a id="2."></a></br>
## 📅 타임 라인
|날짜|내용|
|:--:|--|
|2023.10.09.| 활용할 기술스택 결정<br>프로젝트 구조 구상 |
|2023.10.10.| Network, Model, Error 관련 기본 타입 생성<br>DataScanner 화면인식 기능 구현 |
|2023.10.11.| API 통신을 위한 네트워크 기능 구현<br>Repository 타입 생성<br>ViewModel 생성 |
|2023.10.12.| DataScannerViewController를 MainViewController 내부로 이동<br>언어 선택을 위한 PickerView 추가<br>Item 타입 생성<br>RxSwift 추가하여 ViewModel 변경 |
|2023.10.13.| TextPickerField 타입 생성<br>네트워크 오류 픽스 |
|2023.10.14.| NetworkManager 내부 메서드 분리<br>ColorNamespace 추가<br>Localization 추가 |
|2023.10.15.| 네트워크 테스트 추가<br>ResultViewModel 분리 |
|2023.10.16.| 아이콘 및 런치스크린 생성<br>Copy 작업 추가 |
|2023.10.17.| Toast 메시지 기능 추가<br>README 작성 |

<a id="3."></a></br>
## 🛠️ 활용 기술
|Framework|Architecture|Concurrency|API|Dependency Manager|
|:-:|:-:|:-:|:-:|:-:|
|UIKit|MVVM|RxSwift|Papago 번역, 언어감지|SPM|

<a id="4."></a></br>
## 📊 시각화 구조
### File Tree
    .
    ├── README.md
    └── TranslateApp
        ├── TranslateApp
        │   ├── en.lproj
        │   │   └── Localizable.strings
        │   └── ko.lproj
        │       └── Localizable.strings
        │   ├── App
        │   │   ├── AppDelegate.swift
        │   │   └── SceneDelegate.swift
        │   ├── Network
        │   │   ├── NetworkConfiguration.swift
        │   │   ├── NetworkManager.swift
        │   │   ├── URLSessionDataTaskProtocol.swift
        │   │   └── URLSessionProtocol.swift
        │   ├── Model
        │   │   ├── DTO
        │   │   │   ├── LanguageDetectorDTO.swift
        │   │   │   └── TranslatorDTO.swift
        │   │   └── TranslatorRepository.swift
        │   ├── Utility
        │   │   ├── AlertBuilder.swift
        │   │   ├── CustomColors.swift
        │   │   ├── DecodingManager.swift
        │   │   ├── KeywordArgument.swift
        │   │   ├── Languages.swift
        │   │   └── TranslateItem.swift
        │   ├── Error
        │   │   ├── APIError.swift
        │   │   ├── DecodingError.swift
        │   │   └── TranslateError.swift
        │   ├── Presentation
        │   │   └── View
        │   │       ├── Main
        │   │       │   ├── LanguagePickerField.swift
        │   │       │   ├── MainViewController.swift
        │   │       │   └── MainViewModel.swift
        │   │       ├── Result
        │   │       │   ├── ResultViewController.swift
        │   │       │   └── ResultViewModel.swift
        │   │       └── ViewModelType.swift
        │   ├── Resource
        │   │   └── Assets.xcassets
        │   ├── Info.plist
        │   └── SecretKey.plist
        ├── TranslateApp.xcodeproj
        └── TranslateAppTests
            ├── TranslateApp.xctestplan
            ├── TestDouble.swift
            ├── NetworkTexts.swift
            └── ViewModelTest.swift

### UML
<img src="https://hackmd.io/_uploads/r1Y6ROiZT.png"><br>

<a id="5."></a></br>
## 📱 실행 화면

| 언어 감지 번역 | 선택 언어 번역 | 결과 복사 |
|:-:|:-:|:-:|
|<img src="https://file.notion.so/f/f/26c8d86e-7094-42a2-9751-594e7aa0a176/dd7f7c5d-67af-465b-aee3-9d41770ad6c4/KakaoTalk_Photo_2023-10-17-11-52-52_002.gif?id=cd7be091-3f62-420a-b097-821a41e13200&table=block&spaceId=26c8d86e-7094-42a2-9751-594e7aa0a176&expirationTimestamp=1697601600000&signature=vTgdFQfNSL4d4jMfLoyTw6eA3RYqyJb1sMRPhw67BYw" width="250">|<img src="https://file.notion.so/f/f/26c8d86e-7094-42a2-9751-594e7aa0a176/05783c07-202f-4d54-b6fd-7fa9bd611129/KakaoTalk_Photo_2023-10-17-11-52-51_001.gif?id=906c956e-8dcc-47fe-9269-d717acdfc638&table=block&spaceId=26c8d86e-7094-42a2-9751-594e7aa0a176&expirationTimestamp=1697601600000&signature=HNpbeGy95CNMdSXdVBDcaiGSzK11E_5bnGwRITnp8lQ" width="250">|<img src="https://file.notion.so/f/f/26c8d86e-7094-42a2-9751-594e7aa0a176/c52f1034-67b6-43e4-9d4a-b5a90174dfd9/KakaoTalk_Photo_2023-10-17-11-40-14_002.gif?id=e3989e97-78dd-486e-859e-31425082b372&table=block&spaceId=26c8d86e-7094-42a2-9751-594e7aa0a176&expirationTimestamp=1697601600000&signature=W5XUdpDDn7KoYNT_y1Z-jBri3OFBtWNZoVBnQgwPZeM" width="250">|


<a id="6."></a></br>
## 📌 핵심 경험
#### 🌟 MVVM + Repository 패턴 활용
`input` 타입과 `output` 타입을 분리한 `View Model`을 적용한 `MVVM` 패턴을 활용하였습니다. 또한 네트워크 처리와 연결되는 로직은 `Repository` 타입으로 분리하였습니다.
<details>
<summary>상세코드</summary>
<div markdown="1">

```swift
protocol MainViewModelType {
    var inputs: MainViewModelInputsType { get }
    var outputs: MainViewModelOutputsType { get }
    var resultViewModel: ResultViewModelType { get }
}

protocol MainViewModelInputsType {
    func scanText(_ input: String)
    func touchUpTranslate(source: String, target: String)
}

protocol MainViewModelOutputsType {
    var errorMessage: PublishRelay<String> { get }
}

protocol ResultViewModelType {
    var outputItem: PublishRelay<String> { get }
    var errorMessage: PublishRelay<String> { get }
}

protocol ViewModelWithError {
    var errorMessage: PublishRelay<String> { get }
    func handle(error: Error)
}
```
    
```swift
final class TranslatorRepository {
    let networkManager: NetworkManager
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }

    func detectLanguage(_ text: String, completion: @escaping(Result<Languages, Error>) -> Void) {
        ...
    }
    
    func translate(source: Languages, target: Languages, text: String, completion: @escaping(Result<String, Error>) -> Void) {
        ...
    }
}

```
</div>
</details>
    
#### 🌟 DataScannerViewController를 활용한 언어 스캔 구현
`DataScannerViewController`를 사용하려면 iOS 16 이상이어야 한다는 점이 고민되어, 처음에는 `VNDocumentCameraViewController`를 사용하려 하였습니다. 하지만 그렇게 하면 실시간이라기보다는 한 차례 이미지를 스캔한 뒤 그 중에서 선택하여 텍스트 인식을 하고, 그 후에 번역을 하는 등 단계가 추가되어 실시간 번역이라는 느낌이 들지 않는 것 같았습니다. 결국 `DataScannerViewController`와 `DataScannerViewControllerDelegate`를 활용하여 실시간으로 카메라에 비친 텍스트를 감지할 수 있도록 하였습니다.
<details>
<summary>상세코드</summary>
<div markdown="1">
    
```swift
private let dataScanner: DataScannerViewController = {
    let scanner = DataScannerViewController(recognizedDataTypes: [.text()],
                                            qualityLevel: .balanced,
                                            recognizesMultipleItems: false,
                                            isHighFrameRateTrackingEnabled: true,
                                            isHighlightingEnabled: true)
    scanner.view.translatesAutoresizingMaskIntoConstraints = false
    return scanner
}()

...

extension MainViewController: DataScannerViewControllerDelegate {
    func dataScanner(_ dataScanner: DataScannerViewController,
                     didAdd addedItems: [RecognizedItem],
                     allItems: [RecognizedItem]) {
        guard let item = addedItems.first,
              case .text(let text) = item else { return }
        viewModel.inputs.scanText(text.transcript)
    }
}
```
    
</div>
</details>

#### 🌟 RxSwift를 활용한 데이터 바인딩 구현
`View`와 `View Model` 간의 데이터 바인딩은 물론, `View` 내부의 버튼이나 PickerView 액션에도 `RxSwift`를 활용하였습니다.
<details>
<summary>상세코드</summary>
<div markdown="1">
    
```swift
final class ResultViewModel: ResultViewModelType, ViewModelWithError {
    var outputItem = PublishRelay<String>()
    var errorMessage = PublishRelay<String>()
}
```
    
```swift
private func bindOutput() {
viewModel.outputItem
    .subscribe(on: MainScheduler.instance)
    .bind { [weak self] output in
        guard let self else { return }
        DispatchQueue.main.async {
            self.textView.text = output
        }
    }
    .disposed(by: disposeBag)
}
```

```swift
func bindPickerView(disposeBag: DisposeBag) {
    Observable.just(category.menu).bind(to: pickerView.rx.itemTitles) { _, item in
        return item
    }.disposed(by: disposeBag)

    pickerView.selectRow(0, inComponent: 0, animated: false)
    self.text = category.menu.first
}
```
    
</div>
</details>
    
#### 🌟 Builder 패턴 활용
`Builder` 패턴을 활용해 `Alert` 처리를 조금 더 깔끔히 할 수 있도록 하였습니다.
<details>
<summary>상세코드</summary>
<div markdown="1">
    
```swift
struct AlertBuilder {
    let configuration: AlertConfiguration
    
    init(prefferedStyle: UIAlertController.Style) {
        ...
    }
    
    @discardableResult
    func setTitle(_ title: String) -> Self {
        ...
    }
    
    @discardableResult
    func setMessage(_ message: String) -> Self {
        ...
    }
    
    @discardableResult
    func addAction(_ actionType: AlertActionType, action: ((UIAlertAction) -> Void)? = nil) -> Self {
        ...
    }
    
    func build() -> UIAlertController {
        ...
    }
}
```
    
```swift
let alertBuilder = AlertBuilder(prefferedStyle: .alert)
    .setMessage(errorMessage)
    .addAction(.confirm) { action in
        self.dismiss(animated: true)
    }
    .build()
```
    
</div>
</details>

#### 🌟 Generic을 활용한 범용 메서드 구현
다양한 타입의 Entity를 반환해야 하는 `DecodingManager`의 메서드를 `Generic`으로 구현하였습니다.
<details>
<summary>상세코드</summary>
<div markdown="1">
final class DecodingManager {
    static let shared = DecodingManager()
    let decoder = JSONDecoder()
    
    private init() {}
    
    func decode<T: Decodable>(_ data: Data?) throws -> T {
        guard let data = data,
              let decodedData = try? decoder.decode(T.self, from: data) else {
            throw DecodingError.decodingFailure
        }
        return decodedData
    }
}
```swift

```
    
</div>
</details>
    
#### 🌟 Localization 추가
지역화를 위한 처리를 추가하여 영어와 한국어로 활용할 수 있도록 하였습니다.
<details>
<summary>상세코드</summary>
<div markdown="1">
    
```swift
"languageAuto" = "Detect Language";
"languageKorean" = "Korean";
"languageEnglish" = "English";
"languageJapanese" = "Japanese";
...
```
    
```swift
"languageAuto" = "언어 감지";
"languageKorean" = "한국어";
"languageEnglish" = "영어";
"languageJapanese" = "일본어";
...
```
    
```swift
...
switch self {
case .auto:
    return String(format: NSLocalizedString("languageAuto", comment: "언어 감지"))
case .korean:
    return String(format: NSLocalizedString("languageKorean", comment: "한국어"))
case .english:
    return String(format: NSLocalizedString("languageEnglish", comment: "영어"))
case .japanese:
    return String(format: NSLocalizedString("languageJapanese", comment: "일본어"))
case .chineseSimple:
...
```
    
</div>
</details>
    
#### 🌟 UIToolBar 활용
`UIToolBar`와 `flexibleSpace`를 활용하여 PickerView 상단 버튼을 구현하였습니다.
    
<details>
<summary>상세코드</summary>
<div markdown="1">
    
```swift
private let toolbar: UIToolbar = {
    let toolBar = UIToolbar(frame: CGRect(origin: .zero, size: CGSize(width: UIScreen.main.bounds.width, height: 35)))
    toolBar.translatesAutoresizingMaskIntoConstraints = false
    toolBar.barStyle = .default
    toolBar.isTranslucent = true
    toolBar.tintColor = Colors.barButtonTitle
    toolBar.sizeToFit()
    return toolBar
}()
    
...
    
let cancelButton = UIBarButtonItem(primaryAction: cancel)
let selectButton = UIBarButtonItem(primaryAction: select)
let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

toolbar.setItems([cancelButton, flexibleSpace, selectButton], animated: true)
toolbar.isUserInteractionEnabled = true
self.inputAccessoryView = toolbar
```
    
</div>
</details>

#### 🌟 UITextField와 UIPickerView를 활용한 선택창 구현
`Text Field`에 `Picker View`를 연결한 `LanguagePickerField` 타입을 생성하여 언어 선택이 가능하도록 구현하였습니다.
<details>
<summary>상세코드</summary>
<div markdown="1">

```swift
final class LanguagePickerField: UITextField {
    private let pickerView = UIPickerView()
    
    ...
    
    inputView = pickerView
    
    ...
    
    func bindPickerView(disposeBag: DisposeBag) {
        Observable.just(category.menu).bind(to: pickerView.rx.itemTitles) { _, item in
            return item
        }.disposed(by: disposeBag)

        pickerView.selectRow(0, inComponent: 0, animated: false)
        self.text = category.menu.first
    }
    
    ...
    
}
```
    
</div>
</details>

<a id="7."></a></br>
## 🧨 트러블 슈팅
### 1️⃣ 뷰컨트롤러 내부에 DataScannerViewController 배치
**🚨 문제점**</br>
처음에는 `DataScannerViewController`에서 지니고 있는 `overlayContainerView`에 `Button`과 `TextField`를 배치하려 했습니다. 하지만 그렇게 하면 해당 요소들과 상호작용을 할 수 없다는 것을 깨달았습니다. 뷰를 split해야 할지, 어떻게 하면 뷰 컨트롤러 내부에 `DataScannerViewController`를 넣을 수 있을지 많은 고민을 거쳤습니다.

**💡 해결 방법**</br>
`DataScannerViewController`의 `View`만을 뷰컨트롤러에 `Subview`로 추가해주는 방식으로 문제를 해결하였습니다.
    
```swift
private func configureScanner() {
    dataScanner.delegate = self

    addChild(dataScanner)
    view.addSubview(dataScanner.view)

    NSLayoutConstraint.activate([
        dataScanner.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
        dataScanner.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        dataScanner.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
        dataScanner.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
    ])

    dataScanner.didMove(toParent: self)
}
```


### 2️⃣ Data Scanner의 설정과 번역 결과 표시
**🚨 문제점**</br>
`DataScannerViewContoller`를 활용하면 스캔한 텍스트의 위치정보도 함께 얻을 수 있습니다. 때문에 처음에는 카메라가 인식한 모든 텍스트 위치에 `Label`을 올려 실시간으로 번역된 내용을 표시하려고 했습니다. 이를 위해 `Data Scanner`의 `recognizesMultipleItems`를 `true`로 설정하고, 함께 인식한 내용을 모두 전송하였습니다.
그러나 이렇게 하니 인식 중인 단어가 여러 건이 되면 한 번에 많은 수의 API를 호출하여, OpenAPI의 하루 사용량을 금방 넘겨버리는 이슈가 발생했습니다. 사용량 제한이 없는 API를 활용한다면 좋은 방향이 되겠지만, OpenAPI만을 사용하는 이번 프로젝트에 활용하기에는 적절하지 않다고 판단되었습니다.

**💡 해결 방법**</br>
사용자가 원하는 한 건의 텍스트만 번역할 수 있도록 `Data Scanner`의 설정을 조절하였습니다. 선택한 영역의 번역만 이루어지기 때문에 굳이 한정된 크기의 `Label`을 활용할 필요가 없다고 판단되어 번역 결과는 `Half Sheet` 형태로 새 뷰 컨트롤러에 띄울 수 있도록 설정하였습니다.
```swift
private func configureTranslateButton() {
    translateButton.rx.tap.bind { [weak self] in
        guard let self,
              let source = sourceLanguage.text,
              let target = targetLanguage.text else { return }
        self.viewModel.inputs.touchUpTranslate(source: source, target: target)
        let resultViewController = ResultViewController(self.viewModel.resultViewModel)
        let resultNavigationControllr = UINavigationController(rootViewController: resultViewController)
        DispatchQueue.main.async {
            self.present(resultNavigationControllr, animated: true)
        }
    }.disposed(by: disposeBag)
}
```
    
```swift
final class ResultViewController: UIViewController {
    ...
    if let sheetPresentationController = sheetPresentationController {
        sheetPresentationController.detents = [.medium()]
        sheetPresentationController.prefersGrabberVisible = true
    }
    ...
}
```

### 3️⃣ UIToolBar Frame 문제
**🚨 문제점**</br>
버튼 처리를 위해 UIToolBar를 연결한 후 PickerView를 활성화하면 아래와 같은 Constraint 오류가 계속하여 발생하였습니다. 
<img src="https://hackmd.io/_uploads/SJHDSo9-6.png" width="400">

**💡 해결 방법**</br>
UIToolBar의 frame 설정이 없어 오류가 나는 것으로 확인하여, 아래와 같이 frame을 설정해 해결하였습니다.

```swift
let toolBar = UIToolbar(frame: CGRect(origin: .zero, size: CGSize(width: UIScreen.main.bounds.width, height: 35)))
```


<a id="8."></a></br>
## 📚 참고 자료

> 🍎 : Apple Developer Documentations<br>
> 🟢 : Naver Developers<br>
> ⚪️ : 기타 자료<br>

<br>

[🍎 URLSession](https://developer.apple.com/documentation/foundation/urlsession)<br>
[🍎 URLRequest](https://developer.apple.com/documentation/foundation/urlrequest)<br>
[🍎 URLComponents](https://developer.apple.com/documentation/foundation/urlcomponents)<br>
[🍎 UIAlertController](https://developer.apple.com/documentation/uikit/uialertcontroller)<br>
[🍎 DataScannerViewController](https://developer.apple.com/documentation/visionkit/datascannerviewcontroller)<br>
[🍎 Scanning data with the camera](https://developer.apple.com/documentation/visionkit/scanning_data_with_the_camera)<br>
[🍎 UIPickerView](https://developer.apple.com/documentation/uikit/uipickerview)<br>
[🍎 UIToolbar](https://developer.apple.com/documentation/uikit/uitoolbar)<br>
[🟢 파파고 번역 API](https://developers.naver.com/docs/papago/papago-nmt-overview.md)<br>
[🟢 파파고 언어 감지 API](https://developers.naver.com/docs/papago/papago-detectlangs-overview.md)<br>
[⚪️ RxSwift](https://github.com/ReactiveX/RxSwift)<br>
[⚪️ Kodeco : New Scanning and Text Capabilities with VisionKit](https://www.kodeco.com/36652642-new-scanning-and-text-capabilities-with-visionkit)
</br>
