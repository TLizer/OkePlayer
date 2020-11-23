//
//  PlayerCoordinator.swift
//  OkePlayer
//
//  Created by Tomasz Lizer on 23/11/2020.
//

import UIKit
import AVFoundation

class PlayerCoordinator: Coordinator {
    private let navigationController: UINavigationController
    private let movie: MovieCellViewModel
    private var viewModel: PlayerViewModel?
    private var controller: VideoViewController?
    
    init(navigationController: UINavigationController, movie: MovieCellViewModel) {
        self.navigationController = navigationController
        self.movie = movie
    }
    
    func start() {
        let asset = AVAsset(url: URL(string: movie.url)!)
        let viewModel = PlayerViewModel(playerItem: AVPlayerItem(asset: asset), id: movie.url)
        let movieController = VideoViewController(viewModel: viewModel)
        movieController.modalPresentationStyle = .overFullScreen
        
        viewModel.onDismiss = { [weak self] in
            self?.dismiss()
        }
        
        viewModel.onMinimize = { [weak self] in
            self?.changeMode()
        }
        
        navigationController.present(movieController, animated: true)
        controller = movieController
        self.viewModel = viewModel
    }
    
    func handleAppTermination() {
        viewModel?.persistCurrentTime()
    }
    
    private func dismiss() {
        navigationController.dismiss(animated: true)
        controller = nil
    }
    
    private func changeMode() {
        controller?.displayInfoPopup(message: "To be implemented") { }
    }
}
