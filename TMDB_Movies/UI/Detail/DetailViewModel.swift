//
//  DetailViewModel.swift
//  TMDB_Movies
//
//  Created by KsArT on 26.08.2024.
//

import Foundation

final class DetailViewModel: TaskViewModel {

    @ObservableLock private var _movie: (Movie?) = (nil)
    var movie: ObservableLock<(Movie?)> {
        $_movie
    }

    @ObservableLock private var _poster: (Data?) = (nil)
    var poster: ObservableLock<(Data?)> {
        $_poster
    }

    private let repository: Repository?

    init(repository: Repository?) {
        self.repository = repository
        super.init()
    }

    func loadMovie(by id: Int) {
        launch(named: #function) { [weak self] in
            let result = await self?.repository?.fetchMovie(id: id)
            switch result {
                case .success(let movie):
                    self?._movie = movie
                    let data = await self?.repository?.fetchMoviePoster(path: movie.posterPath, small: false)
                    switch data {
                        case .success(let poster):
                            self?._poster = poster
                        default: break
                    }

                case .failure(let error):
                    print(error)
                case .none:
                    break
            }
        }
    }
}
