//
//  PlayPauseControl.swift
//  OkePlayer
//
//  Created by Tomasz Lizer on 21/11/2020.
//

import UIKit

class PlayPauseControl: UIControl {
    enum Mode {
        case play, pause
    }
    
    private let imageView = UIImageView()
    var mode: Mode {
        didSet {
            updateImage()
        }
    }
    
    init(frame: CGRect = .zero, mode: Mode = .play) {
        self.mode = mode
        
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        imageView.embed(in: self)
        imageView.tintColor = UIColor.white.withAlphaComponent(0.8)
        updateImage()
    }
    
    private func updateImage() {
        switch mode {
        case .play:
            imageView.image = UIImage(named: "play_icon")?.withRenderingMode(.alwaysTemplate)
        case .pause:
            imageView.image = UIImage(named: "pause_icon")?.withRenderingMode(.alwaysTemplate)
        }
    }
}
