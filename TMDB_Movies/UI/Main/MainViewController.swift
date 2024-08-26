//
//  ViewController.swift
//  TMDB_Movies
//
//  Created by KsArT on 23.08.2024.
//

import UIKit

class MainViewController: UIViewController {

    private let viewModel = MainViewModel()

    @IBOutlet weak var moviesTable: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
        initData()
    }

    private func initView() {
        moviesTable.delegate = self
        moviesTable.dataSource = self
    }

    // MARK: - binding
    private func initData() {
        viewModel.errorMessage.observe { message in
            guard !message.isEmpty else { return }
            
            print("Error: \(message)")
        }

        viewModel.movies.observe { [weak self] movies in
            guard let self, !movies.isEmpty else { return }

            self.moviesTable.reloadData()
        }
        viewModel.posterMovie.observe { indexPath in
            guard let indexPath else { return }

            // после загрузки постера, обновим ячейку
            self.moviesTable.reloadRows(at: [indexPath], with: .fade)
        }
    }
}

// MARK: - TableViewDataSource
extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.movies.wrappedValue.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.row < viewModel.movies.wrappedValue.count else {
            fatalError("'MovieCell' row=\(indexPath.row) > count=\(viewModel.movies.wrappedValue.count)")
        }

        let movie = viewModel.movies.wrappedValue[indexPath.row]

        let cell = moviesTable.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath)

        cell.textLabel?.text = movie.title
        cell.detailTextLabel?.text = movie.originalTitle
        // установим постер
        if let poster = viewModel.poster(by: movie.id) {
            cell.imageView?.image =  UIImage(data: poster)
        } else {
            // поставим заглушку
            cell.imageView?.image = UIImage(named: "poster")
            // загрузим постер
            viewModel.loadPoster(by: movie.id, of: movie.posterPath, for: indexPath)
        }

        return cell
    }

}

// MARK: - TableViewDelegate
extension MainViewController: UITableViewDelegate {

}
