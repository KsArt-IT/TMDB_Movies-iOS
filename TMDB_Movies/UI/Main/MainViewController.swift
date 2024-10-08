//
//  ViewController.swift
//  TMDB_Movies
//
//  Created by KsArT on 23.08.2024.
//

import UIKit

class MainViewController: UIViewController, ViewControllerCreator {

    private var viewModel: MainViewModel!

    @IBOutlet weak var moviesTable: UITableView!
    @IBOutlet weak var loaderView: UIActivityIndicatorView!
    @IBOutlet weak var pregressView: UIProgressView!
    @IBOutlet weak var reloadButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
        initData()
    }

    func setViewModel(_ viewModel: MainViewModel) {
        self.viewModel = viewModel
    }

    private func initView() {
        title = R.Strings.titleTopMovies
        reloadButton.titleLabel?.text = R.Strings.titleReloadButton
        reloadButton.isHidden = true
        pregressView.progress = 0
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
            self?.showTableFooterLoader(loading)
        }

        viewModel.errorMessage.observe { [weak self] message in
            guard !message.isEmpty else { return }

            self?.reloadButton.isHidden = false
            self?.showAlert(title: "Error", message: message)
        }

        viewModel.movies.observe { [weak self] movies in
            guard let self, !movies.isEmpty else { return }
            pregressView.progress = viewModel.progress
//            print("-----------------reloadData--------------------\(pregressView.progress)")
            self.moviesTable.reloadData()
        }
        
        viewModel.posterReload.observe { indexPath in
            guard let indexPath else { return }

            // после загрузки постера, обновим ячейку
            self.moviesTable.reloadRows(at: [indexPath], with: .fade)
        }
    }

    @IBAction func reloadData(_ sender: UIButton) {
        sender.isHidden = true
        viewModel.reloadPage()
    }

    private func showTableFooterLoader(_ show: Bool = true) {
        moviesTable.tableFooterView = show ? createTableFooter() : nil
    }

    private func createTableFooter() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: moviesTable.contentSize.width, height: 100))
        let spinner = UIActivityIndicatorView()
        spinner.center = footerView.center
        footerView.addSubview(spinner)
        spinner.startAnimating()
        return footerView
    }

    private func showDetail(_ id: Int) {
        viewModel.showDetail(id)
    }

    private func showAlert(title: String = "", message: String) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default)
            alert.addAction(okAction)
            present(alert, animated: true)
        }

    deinit {
        print("MainViewController.deinit")
    }
}

// MARK: - TableViewDataSource
extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.count
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

// MARK: - ScrollViewDelegate
extension MainViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = moviesTable.contentSize.height - (scrollView.frame.size.height + scrollView.contentOffset.y)
        if offset < 100 {
            viewModel.loadPagination()
        }
    }
}
