//
//  ViewController.swift
//  TMDB_Movies
//
//  Created by KsArT on 23.08.2024.
//

import UIKit

class ViewController: UIViewController {

    private let viewModel = MainViewModel()

    @IBOutlet weak var titleLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        initData()
        viewModel.updateMovies()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            self?.viewModel.updateMovies()
        }
    }

    private func initData() {
        viewModel.errorMessage.observe { message in
            guard !message.isEmpty else { return }
            
            print("Error: \(message)")
        }

        viewModel.movies.observe { [weak self] movies in
            guard let self, !movies.isEmpty else { return }

            self.titleLabel.text = movies[0].title
            print(movies)
            print("-------------------------------------------------------------")
        }
    }
}

