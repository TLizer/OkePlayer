//
//  PlayerViewController.swift
//  OkePlayer
//
//  Created by Tomasz Lizer on 21/11/2020.
//

import UIKit
import AVFoundation

class VideoViewController: UIViewController {
    private lazy var playerLayer = AVPlayerLayer(player: viewModel.player)
    private let viewModel: PlayerViewModel
    
    init(viewModel: PlayerViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black
        playerLayer.frame = view.frame
        view.layer.addSublayer(playerLayer)
        
        viewModel.setupPlayer()

        let overlayView = PlayerOverlayView()
        view.addSubview(overlayView)
        overlayView.embed(in: view.safeAreaLayoutGuide)
        overlayView.viewModel = viewModel
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if viewModel.canRestore {
            self.displayAcceptPopup(message: "Do you want to restore from where you left?") { result in
                self.viewModel.startPlayer(startFormBeggining: !result)
            }
        } else {
            viewModel.startPlayer(startFormBeggining: true)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        playerLayer.frame = view.bounds
    }
}
