# ImageSearch

**ImageSearch** — это iOS-приложение для поиска и просмотра медиа-контента с использованием Unsplash API. Оно позволяет пользователю искать изображения, просматривать детальную информацию, сохранять изображения в галерею и делиться ими через UIActivityViewController.

## Функции:

- Поиск изображений по ключевым словам
- История поиска с подсказками (до 5 последних запросов)
- Просмотр детальной информации об изображении: изображение в большем формате,описание, автор
- Сохранение изображения в галерею
- Возможность поделиться изображением с друзьями

## Требования

- iOS 16.1+
- Xcode 15.0+
- Swift 5.0+

## Установка

1. Склонируйте репозиторий:

    ```bash
    git clone https://github.com/yourusername/ImageSearch.git
    ```

2. Откройте проект в Xcode:

    ```bash
    cd ImageSearch
    open ImageSearch.xcodeproj
    ```

3. Соберите и запустите проект в симуляторе или на устройстве.

## Использование

### Экран поиска

- Введите поисковый запрос в строку поиска.
- Приложение отобразит изображения в виде плиток.
- Нажмите на изображение, чтобы открыть детальную информацию.

### Экран с детальной информацией

- Отображает изображение в большем формате, описание и информацию об авторе.
- Имеется возможность:
  - Сохранить изображение в галерею.
  - Поделиться изображением с помощью стандартного меню iOS (UIActivityViewController).

## Архитектура

Проект построен на основе архитектуры **MVP** (Model-View-Presenter).

- **Model**: Обрабатывает сетевые запросы и хранит данные о медиа-контенте.
- **View**: Отображает пользовательский интерфейс и взаимодействует с пользователем.
- **Presenter**: Связывает View и Model, обрабатывает логику приложения.

### Основные классы и компоненты:

- **SearchViewController**: Управляет экраном поиска и отображает результаты.
- **DetailViewController**: Отображает детальную информацию об изображении.
- **SearchPresenter / DetailPresenter**: Обрабатывают логику поиска и отображения информации.
- **NetworkService**: Управляет сетевыми запросами к Unsplash API.

## Лицензия

Этот проект лицензирован под лицензией MIT. Подробности можно найти в файле [LICENSE](LICENSE).
