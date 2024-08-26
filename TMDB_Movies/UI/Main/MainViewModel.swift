//
//  MainViewModel.swift
//  TMDB_Movies
//
//  Created by KsArT on 24.08.2024.
//

import Foundation

final class MainViewModel: TaskViewModel {

    private var page: Int = 1

    @ObservableLock private var _movies: [Movie] = []
    var movies: ObservableLock<[Movie]> {
        $_movies
    }

    @ObservableLock private var _posterMovie: (IndexPath?) = (nil)
    var posterMovie: ObservableLock<(IndexPath?)> {
        $_posterMovie
    }

    @ObservableLock private var _errorMessage: String = ""
    var errorMessage: ObservableLock<String> {
        $_errorMessage
    }

    private var _poster: [Int: Data] = [:]

    private let repository: Repository?

    init(repository: Repository? = ServiceLocator.shared.resolve()) {
        self.repository = repository
        super.init()

        updateMovies()
    }

    // загрузим порцию фильмов
    func updateMovies() {
        launch(named: #function) { [weak self] in
            guard let self else { return }

            let result = await self.repository?.fetchTopMovies(page: self.page)
            switch result {
                case .success(let movies):
                    self.page += 1
                    // добавляем порцию фильмов не проверяя
                    self._movies += movies
                    //                self.addMovies(movies)
                case .failure(let error):
                    self._errorMessage = (error as? NetworkServiceError)?.localizedDescription ?? error.localizedDescription
                case .none:
                    break
            }
        }
    }

    // Добавим порцию только новых фильмов
    private func addMovies(_ movies: [Movie]) {
        guard !movies.isEmpty else { return }

        // Добавим только те фильмы, которые еще не содержатся в текущем массиве
        let existingMovies = Set($_movies.wrappedValue.map { $0.id })
        let newMovies = movies.filter { !existingMovies.contains($0.id) }
        if !newMovies.isEmpty {
            _movies += newMovies
        }
    }

    func poster(by id: Int) -> Data? {
        _poster[id]
    }

    func loadPoster(by id: Int, of path: String, for indexPath: IndexPath) {
        launch { [weak self] in
            guard let self else { return }

            let result = await self.repository?.fetchMoviePoster(path: path, small: true)
            switch result {
                case .success(let data):
                    _poster[id] = data
                    _posterMovie = indexPath
                default: break
            }
        }
    }
}
