# Avito Test App
## Демонстрация работы
#### Так приложение работает на главном экране:
![](https://github.com/v1adisLuvv/AvitoTestApp/blob/master/general.gif)
Как только загрузился main json показывается Collection View с серыми заглушками вместо картинок.
Картинки отображаются по мере загрузки. Для того чтобы картинки отображались в нужных ячейках используется проверка по ID (из-за переспользования ячеек).
После того как картинка была загружена, она добавляется в кэш, и в следующий раз будет загружена из него.

#### Экран деталей:
![](https://github.com/v1adisLuvv/AvitoTestApp/blob/master/detail.gif)
На экране деталей поведение схоже с главным экраном. Сначала показываются надписи, потом отображается картинка по мере загрузки.

#### Состояние загрузки:
![](https://github.com/v1adisLuvv/AvitoTestApp/blob/master/loading.gif)
В состоянии загрузки отображается дефолтный activity indicator.

#### Состояние ошибки:
![](https://github.com/v1adisLuvv/AvitoTestApp/blob/master/timeout.gif) ![](https://github.com/v1adisLuvv/AvitoTestApp/blob/master/timeout.png) 
В случае плохого соединения после таймаута на экране будет написано "Timeout".

![](https://github.com/v1adisLuvv/AvitoTestApp/blob/master/loading.gif)
В случае отсутствия соединения на экране будет написано "Нет подключения к интенету".

## Стeк разработки
* UIKit + AutoLayout(constraints in code, no Storyboard)
* MVVM
* Combine (data binding)
* Swift Concurrency
* URLSession
* Caching via NSCache

## Структура приложения
За сетевый запросы отвечает NetworkRouter (low-level requests):
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