//
//  MoviesListVC.swift
//  TMDB_Assignment
//
//  Created by Tarun on 27/10/25.
//

import Foundation
import UIKit

class MoviesListVC: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    private let viewModel = MovieListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Movie List"
        
        viewModel.fetchMovie()
        setupTableView()
        observeEvent()
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "MovListCell", bundle: nil), forCellReuseIdentifier: "MovListCell")
        //        tableView.separatorStyle = .none
        tableView.bounces = false
    }
}

extension MoviesListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.MoviesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovListCell", for: indexPath) as! MovListCell
        
        let data = viewModel.MoviesArray[indexPath.row]
        
        cell.configure(data: data)
        
        cell.onFavoriteToggled = { [weak self, weak tableView] movieId, isFav in
            guard let self = self, let tableView = tableView else { return }
            if let row = viewModel.MoviesArray.firstIndex(where: { ($0.id ?? -1) == movieId }) {
                let ip = IndexPath(row: row, section: 0)
                tableView.reloadRows(at: [ip], with: .none)
            } else {
                tableView.reloadData()
            }

            print("Movie \(movieId) isFav: \(isFav)")
        }

        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MovieDetailVC") as! MovieDetailVC
        vc.movieID = viewModel.MoviesArray[indexPath.row].id
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

extension MoviesListVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.trimmingCharacters(in: .whitespaces).isEmpty {
            viewModel.fetchMovie()
        } else {
            viewModel.searchMovie(query: searchText)
        }
        DispatchQueue.main.async {
            self.title = searchText.isEmpty ? "Movie List" : "Search"
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

extension MoviesListVC {
    func observeEvent() {
        viewModel.eventHandler = { [weak self] event in
            guard let self = self else { return }
            switch event {
            case .loading:
                print("Data Loading")
            case .stopLoading:
                print("Data Stoped Loading")
            case .dataLoaded:
                print("Data Loaded")
            case .error(let error):
                print(error)
            case .moviesDetailsFetched(data: let Movie):
                self.viewModel.MoviesArray = Movie.results
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            case .movieSearched(data: let data):
                self.viewModel.MoviesArray = data.results
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
}
