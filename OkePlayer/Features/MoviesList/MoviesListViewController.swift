//
//  MoviesListViewController.swift
//  OkePlayer
//
//  Created by Tomasz Lizer on 19/11/2020.
//

import UIKit
import AVFoundation

class MoviesListViewController: UIViewController {
    private let moviesItems: [MovieCellViewModel]
    var movieSelected: ((MovieCellViewModel) -> Void)?
    
    private let tableView: UITableView = {
       let tableView = UITableView()
        tableView.register(MovieItemCell.self, forCellReuseIdentifier: MovieItemCell.reuseIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        return tableView
    }()
    
    init(moviesItems: [MovieCellViewModel]) {
        self.moviesItems = moviesItems
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Movies"
        
//        view.addSubview(tableView)
//        tableView.embed(in: view.safeAreaLayoutGuide)
        tableView.embed(in: view)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
    }
}

extension MoviesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        moviesItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(for: indexPath, type: MovieItemCell.self)
        let item = moviesItems[indexPath.row]
        cell.bind(with: item)
        return cell
    }
}

extension MoviesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        movieSelected?(moviesItems[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
