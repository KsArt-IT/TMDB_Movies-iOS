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
    private var _numberOfRows = 0
    var numberOfRows: Int {
        _movies.count == 0 || page > pageCount ? _movies.count : _numberOfRows
    }
    private var pageCount = 0
    private var page = 0
    private var pageLoading = 0

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
    // используется из нескольких потоков одновременно
    @ObservableLock private var _poster: [Int: Data] = [:]

    @ObservableLock private var _errorMessage: String = ""
    var errorMessage: ObservableLock<String> {
        $_errorMessage
    }

    var pregress: Float {
        count == numberOfRows || numberOfRows == 0 ? 1.0 : Float(count) / Float(numberOfRows) + 0.01
    }

    private let repository: Repository?

    init(repository: Repository?) {
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

    func reloadPage() {
        loadMovies()
    }

    // загрузим порцию фильмов
    private func loadMovies() {
        guard page <= pageCount else { return }
        pageLoading = page
        launch(named: #function) { [weak self] in
            guard let self else { return }

            self._loading = true
            print("page=\(self.page)")
            let result = await self.repository?.fetchTopMovies(page: self.page)
            switch result {
                case .success(let movies):
                    self.page += 1
                    // предзагрузим постер с индексом
                    await self.preloadPoster(movies)
                    // добавляем порцию фильмов не проверяя
                    self._movies += movies
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

        let movie = _movies[index]
        print("index=\(index), movie id=\(movie.id) title='\(movie.title)'")
        return movie
    }

    func getPoster(by id: Int) -> Data? {
        _poster[id]
    }

    private func preloadPoster(_ movies: [Movie]) async {
        guard !movies.isEmpty else { return }

        for movie in movies {
            if _poster[movie.id] == nil {
                print("preloadPoster id=\(movie.id)")
                launch { [weak self] in
                    let result = await self?.repository?.fetchMoviePoster(path: movie.posterPath, small: true)
                    switch result {
                        case .success(let data):
                            self?._poster[movie.id] = data
                        default: break
                    }
                }
            }
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
                    self?._numberOfRows = count
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
        // дозагрузка только если мы не загружаем эту страницу
        if page <= pageCount && page != pageLoading && index + loadWhenLastIndex >= _movies.count {
            print("---дозагрузка---")
            loadMovies()
        }
    }
}
