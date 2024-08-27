//
//  MainViewModel.swift
//  TMDB_Movies
//
//  Created by KsArT on 24.08.2024.
//

import Foundation

final class MainViewModel: TaskViewModel {

    // начать дозагрузку когда до последний элемент раньше на ...
    private let loadWhenLastIndex = 10
    // установим количество страниц и всего элементов при первой загрузке
    private(set) var numberOfRows = 0
    private var pageCount = 0
    private var page = 0

    @ObservableLock private var _loading: Bool = false
    var loading: ObservableLock<Bool> {
        $_loading
    }

    @ObservableLock private var _movies: [Movie] = []
    var movies: ObservableLock<[Movie]> {
        $_movies
    }
    var count: Int {
        _movies.count
    }

    @ObservableLock private var _posterReload: (IndexPath?) = (nil)
    var posterReload: ObservableLock<(IndexPath?)> {
        $_posterReload
    }
    private var _poster: [Int: Data] = [:]

    @ObservableLock private var _errorMessage: String = ""
    var errorMessage: ObservableLock<String> {
        $_errorMessage
    }

    private let repository: Repository?

    init(repository: Repository? = ServiceLocator.shared.resolve()) {
        self.repository = repository
        super.init()

        reload()
    }

    func reload() {
        launch { [weak self] in
            self?._loading = true
            // установим начальную страницу
            self?.page = TmdbEndpoint.pageInit
            // загрузим количество всего фильмов
            self?.updateMoviesCount {
                self?._movies = []
                self?.loadMovies()
            } error: {
                self?._loading = false
            }
        }
    }

    // загрузим порцию фильмов
    private func loadMovies() {
        guard page <= pageCount else {
            print("end: page=\(page) = \(pageCount), count=\(numberOfRows) = \(_movies.count)")
            print("-----------------------------------------")
            // поставим максимум что есть
            numberOfRows = _movies.count
            return
        }

        launch(named: #function) { [weak self] in
            guard let self else { return }

            self._loading = true
            print("page=\(self.page)")
            let result = await self.repository?.fetchTopMovies(page: self.page)
            switch result {
                case .success(let movies):
                    self.page += 1
                    if self.page > self.pageCount {
                        self.numberOfRows = self._movies.count + movies.count
                    }
                    // предзагрузим постер с индексом
                    let index = self._movies.count
                    // добавляем порцию фильмов не проверяя
                    self._movies += movies
                    self.preloadPoster(index)
                case .failure(let error):
                    self._errorMessage = (error as? NetworkServiceError)?.localizedDescription ?? error.localizedDescription
                case .none:
                    break
            }
            self._loading = false
        }
    }

    func getMovie(index: Int) -> Movie? {
        // дозагрузим по необходимости
        paginationLoad(index)
        guard  case 0..<_movies.count = index else { return nil }

        preloadPoster(index + 1)
        let movie = _movies[index]
        print("index=\(index), movie id=\(movie.id) title='\(movie.title)'")
        return movie
    }

    func getPoster(by id: Int) -> Data? {
        _poster[id]
    }

    private func preloadPoster(_ index: Int) {
        guard index < _movies.count else { return }
        do {
            let movie = _movies[index]
//            let poster = try? _poster[movie.id]
            if try _poster[movie.id] == nil {
                print("preloadPoster index=\(index)")
                launch { [weak self] in
                    let result = await self?.repository?.fetchMoviePoster(path: movie.posterPath, small: true)
                    switch result {
                        case .success(let data):
                            self?._poster[movie.id] = data
                        default: break
                    }
                }
            }
        } catch {

        }
    }

    func loadPoster(by id: Int, of path: String, for indexPath: IndexPath) {
        launch { [weak self] in
            let result = await self?.repository?.fetchMoviePoster(path: path, small: true)
            switch result {
                case .success(let data):
                    self?._poster[id] = data
                    self?._posterReload = indexPath
                default: break
            }
        }
    }

    // MARK: - Pagination
    private func updateMoviesCount(completion: @escaping () -> Void, error: @escaping () -> Void) {
        launch(named: #function) { [weak self] in
            let result = await self?.repository?.fetchTopMoviesCount()
            switch result {
                case let .success((pages, count)):
                    self?.pageCount = pages
                    self?.numberOfRows = count
                    print("---------------------------")
                    print("pages=\(pages), count=\(count)")
                    print("---------------------------")
                    completion()
                default:
                    error()
            }
        }
    }

    private func paginationLoad(_ index: Int) {
        // дозагрузка
        if numberOfRows > _movies.count && index + loadWhenLastIndex >= _movies.count {
            print("---дозагрузка---")
            loadMovies()
        }
    }
}
