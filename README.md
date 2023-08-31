# Avito Test App
## Демонстрация работы
### Так приложение работает на главном экране:
Как только загрузился main json показывается Collection View с серыми заглушками вместо картинок.
Картинки отображаются по мере загрузки. Для того чтобы картинки отображались в нужных ячейках используется проверка по ID (из-за переспользования ячеек).
После того как картинка была загружена, она добавляется в кэш, и в следующий раз будет загружена из него.

<img src="https://github.com/v1adisLuvv/AvitoTestApp/blob/master/Images/general.gif" width="20%">

### Экран деталей:
На экране деталей поведение схоже с главным экраном. Сначала показываются надписи, потом отображается картинка по мере загрузки.

<img src="https://github.com/v1adisLuvv/AvitoTestApp/blob/master/Images/detail.gif" width="20%">

### Состояние загрузки:
В состоянии загрузки отображается дефолтный activity indicator.

<img src="https://github.com/v1adisLuvv/AvitoTestApp/blob/master/Images/loading.gif" width="20%">

### Состояние ошибки:
В случае плохого соединения после таймаута на экране будет написано "Timeout".

<p float="left">
    <img src="https://github.com/v1adisLuvv/AvitoTestApp/blob/master/Images/timeout.gif" width="20%">
    <img src="https://github.com/v1adisLuvv/AvitoTestApp/blob/master/Images/timeout.png" width="20%">
</p>

В случае отсутствия соединения на экране будет написано "Нет подключения к интенету".

<img src="https://github.com/v1adisLuvv/AvitoTestApp/blob/master/Images/noConnection.png"  width="20%">

В других случаях на экране будет написано "Ошибка". В случае ошибки загрузки картинок они просто не покажутся, а ошибка будет напечатана в консоль.

## Стeк разработки
* UIKit + AutoLayout(constraints in code, no Storyboard)
* MVVM
* Combine (data binding)
* Swift Concurrency
* URLSession
* Caching via NSCache

## Структура приложения
За сетевыe запросы отвечает NetworkRouter (low-level requests):
```swift
protocol NetworkRouter {
    func request<Endpoint: EndpointType>(_ route: Endpoint) async throws -> Data
    func loadImage(from url: String) async throws -> Data
}
```
Каждый API запрос представлен в виде Endpoint'a:
```swift
// every network request should be performed via Endpoint object that conforms to this protocol
protocol EndpointType {
    var baseURL: URL { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var timeoutInterval: TimeInterval { get }
}
```
Изображение загружается напрямую по URL.

За взаимодействия с API отвечает NetworkManager:
```swift
protocol NetworkManager {
    func getAdvertisements() async throws -> [Advertisement]
    func getDetailAdvertisement(id: Int) async throws -> Advertisement
    func getImage(from url: String) async throws -> Data
}
```

Для кэширования используется класс ImageCache, который для удобства был сделан синглтоном, так как приложение небольшое.

У каждого экрана и каждой ячейки есть своя вью-модель.

Для отображения состояния экрана используется enum ScreenState:
```swift
enum ScreenState {
    case error(message: String)
    case downloading
    case content
}
```
