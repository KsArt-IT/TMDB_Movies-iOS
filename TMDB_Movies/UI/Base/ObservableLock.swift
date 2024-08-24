//
//  Observable.swift
//  TMDB_Movies
//
//  Created by KsArT on 24.08.2024.
//

import Foundation

@propertyWrapper
final class ObservableLock<T> {

    typealias Observer = (T) -> Void
    // Замыкание, которое будет вызываться при изменении значения
    private var observer: Observer?

    private let mutex = NSLock()

    // Наблюдаемая переменная
    private var value: T
    public var wrappedValue: T {
        get {
            mutex.lock()
            defer { mutex.unlock() }
            return value
        }
        set {
            mutex.lock()
            value = newValue
            let currentObserver = observer
            mutex.unlock()
            if let currentObserver {
                giveValue(value, to: currentObserver)
            }
        }
    }

    // Добавляем projectedValue для доступа к обертке и через $ получение доступа к func observe
    var projectedValue: ObservableLock<T> {
        return self
    }

    init(wrappedValue: T) {
        self.value = wrappedValue
    }

    // Наблюдаем за изменением значения переменной
    public func observe(observer: @escaping Observer) {
        mutex.lock()
        self.observer = observer
        let currentValue = value
        mutex.unlock()
        giveValue(currentValue, to: observer)
    }

    // Отдаем данные на main потоке
    private func giveValue(_ value: T, to observer: @escaping Observer) {
        Task { @MainActor in
            observer(value)
        }
    }
}

// MARK: - Пример использования
/*
// ViewModel
class MyViewModel {
    // приватная переменная для изменения
    @ObservableLock private var _movies: [Movie] = []
    // переменная для наблюдения в контроллере
    var movies:  ObservableLock<[Movie]>  {
        $_movies
    }
}

// ViewController
class MyViewController: UIViewController {
    private var viewModel = MyViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.movies.observe { [weak self] _ in
            // Выполниться на main потоке
            self?.tableView.reloadData()
        }
    }
}
*/
