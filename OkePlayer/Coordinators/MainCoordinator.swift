//
//  MainCoordinator.swift
//  OkePlayer
//
//  Created by Tomasz Lizer on 21/11/2020.
//

import UIKit
import AVFoundation

class MainCoordinator: Coordinator {
    private let window: UIWindow
    private let navigationController: UINavigationController
    private var moviesListCoordinator: MoviesListCoordinator?
    private var playerCoordinator: PlayerCoordinator?
    
    init(window: UIWindow) {
        self.window = window
        navigationController = UINavigationController()
    }
    
    func start() {
        window.rootViewController = navigationController
        moviesListCoordinator = MoviesListCoordinator(displayContainer: navigationController) { [weak self] movie in
            self?.display(movie: movie)
        }
        moviesListCoordinator?.start()
        window.makeKeyAndVisible()
    }
    
    func handleAppTermination() {
        playerCoordinator?.handleAppTermination()
    }
    
    private func display(movie: MovieCellViewModel) {
        playerCoordinator = PlayerCoordinator(navigationController: navigationController, movie: movie)
        playerCoordinator?.start()
    }
}

