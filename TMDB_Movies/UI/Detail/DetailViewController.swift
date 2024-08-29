//
//  DetailViewController.swift
//  TMDB_Movies
//
//  Created by KsArT on 26.08.2024.
//

import UIKit

class DetailViewController: UIViewController, ViewControllerCreator {

    var viewModel: DetailViewModel!

    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var originalLabel: UILabel!
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var popularityLabel: UILabel!
    @IBOutlet weak var averageLabel: UILabel!
    @IBOutlet weak var overviewView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
        initData()
    }

    private func initView() {
        title = R.Strings.titleMovieDetail
    }

    private func initData() {
        viewModel.movie.observe { [weak self] movie in
            guard let movie else { return }

            self?.updateView(movie: movie)
        }
        viewModel.poster.observe { [weak self] data in
            guard let data else { return }

            self?.posterView.image = UIImage(data: data)
        }
    }

    private func updateView(movie: Movie) {
        titleLabel.text = movie.title
        originalLabel.text = movie.originalTitle
        dataLabel.text = movie.releaseDate
        genresLabel.text = movie.genres.joined(separator: ", ")
        popularityLabel.text = "\(movie.popularity)"
        averageLabel.text = "\(movie.voteAverage)/\(movie.voteCount)"
        overviewView.text = movie.overview
    }

    deinit {
        print("DetailViewController.deinit")
    }
}
