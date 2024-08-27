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
    @IBOutlet weak var loaderView: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
        initData()
    }

    private func initView() {
        title = R.Strings.titleTopMovies
        // настроим делегаты
        moviesTable.delegate = self
        moviesTable.dataSource = self
        // прозрачный фон для таблицы
        moviesTable.backgroundColor = .clear
        // стиль разделителя
        moviesTable.separatorStyle = .singleLine
        moviesTable.separatorColor = .tableSeparator
    }

    // MARK: - binding
    private func initData() {
        viewModel.loading.observe { [weak self] loading in
            if loading {
                self?.loaderView.startAnimating()
            } else {
                self?.loaderView.stopAnimating()
            }
        }

        viewModel.errorMessage.observe { message in
            guard !message.isEmpty else { return }
            
            print("Error: \(message)")
        }

        viewModel.movies.observe { [weak self] movies in
            guard let self, !movies.isEmpty else { return }
            print("-----------------reloadData--------------------")
            self.moviesTable.reloadData()
        }
        
        viewModel.posterReload.observe { indexPath in
            guard let indexPath else { return }

            // после загрузки постера, обновим ячейку
            self.moviesTable.reloadRows(at: [indexPath], with: .fade)
        }
    }

    private func showDetail(_ id: Int) {
        let storyboard = UIStoryboard(name: "Detail", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DetailViewController")
        (vc as? MovieIdDelegate)?.setMovie(by: id)
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - TableViewDataSource
extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath)
        // поставим заглушку
        cell.imageView?.image = R.Images.poster

        if let movie = viewModel.getMovie(index: indexPath.row) {
            cell.textLabel?.text = movie.title
            cell.detailTextLabel?.text = movie.originalTitle
            // установим постер
            if let poster = viewModel.getPoster(by: movie.id) {
                cell.imageView?.image =  UIImage(data: poster)
            } else {
                // загрузим постер
                viewModel.loadPoster(by: movie.id, of: movie.posterPath, for: indexPath)
            }
        }
        return cell
    }

}

// MARK: - TableViewDelegate
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let movie = viewModel.getMovie(index: indexPath.row)  else { return }

        showDetail(movie.id)
    }
}

protocol MovieIdDelegate {
    func setMovie(by id: Int)
}
