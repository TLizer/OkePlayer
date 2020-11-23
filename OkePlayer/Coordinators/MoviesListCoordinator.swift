//
//  MoviesListCoordinator.swift
//  OkePlayer
//
//  Created by Tomasz Lizer on 21/11/2020.
//

import AVFoundation

class MoviesListCoordinator: Coordinator {
    private let displayContainer: DisplayContainer
    private var listController: MoviesListViewController?
    private var movieSelected: (MovieCellViewModel) -> Void
    
    init(displayContainer: DisplayContainer, movieSelected: @escaping (MovieCellViewModel) -> Void) {
        self.displayContainer = displayContainer
        self.movieSelected = movieSelected
    }
    
    func start() {
        let controller = MoviesListViewController(moviesItems: prepareMovies())
        controller.movieSelected = { [weak self] movie in
            self?.movieSelected(movie)
        }
        displayContainer.display(viewController: controller)
        listController = controller
    }
    
    private func prepareMovies() -> [MovieCellViewModel] {
        let urls = [
            "http://devimages.apple.com/samplecode/adDemo/ad.m3u8",
            "https://bit.ly/2ZKwDrA",
            "https://bitdash-a.akamaihd.net/content/sintel/hls/playlist.m3u8",
        ]
        return urls.map { MovieCellViewModel(title: $0, url: $0, thumbnail: nil)}
    }
}
