//
//  PlayerOverlayView.swift
//  OkePlayer
//
//  Created by Tomasz Lizer on 21/11/2020.
//

import UIKit

class PlayerOverlayView: UIView {
    private let exitButton: UIButton = {
        let button = UIButton()
        button.imageView?.tintColor = UIColor.white.withAlphaComponent(0.8)
        button.setImage(UIImage(named: "x_button")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    private let minimizeButton: UIButton = {
        let button = UIButton()
        button.imageView?.tintColor = UIColor.white.withAlphaComponent(0.8)
        button.setImage(UIImage(named: "chevron_down")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    private let spinner = UIActivityIndicatorView(style: .whiteLarge)
    private let playPauseControl = PlayPauseControl(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
    private let timeline = TimelineView()
    private var timer: Timer?
    var dismiss: (() -> Void)?
    
    var viewModel: PlayerViewModel? {
        didSet { bind(with: viewModel) }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        setupButtons()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        timer?.invalidate()
    }
    
    private func setupUI() {
        addSubviews([playPauseControl, timeline, exitButton, minimizeButton, spinner])
        
        timeline.translatesAutoresizingMaskIntoConstraints = false
        timeline.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        timeline.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        timeline.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        exitButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        exitButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -5).isActive = true
        exitButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        exitButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        minimizeButton.translatesAutoresizingMaskIntoConstraints = false
        minimizeButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        minimizeButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 5).isActive = true
        minimizeButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        minimizeButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        spinner.pinToCenter(in: self)
        spinner.startAnimating()
        
        playPauseControl.pinToCenter(in: self)
        playPauseControl.isHidden = true
    }
    
    private func setupButtons() {
        playPauseControl.addTarget(self, action: #selector(tappedPlayPause), for: .touchUpInside)
        exitButton.addTarget(self, action: #selector(tappedExit), for: .touchUpInside)
        minimizeButton.addTarget(self, action: #selector(tappedMinimize), for: .touchUpInside)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tappedOverlay))
        tap.delegate = self
        self.addGestureRecognizer(tap)
    }
    
    @objc
    private func tappedExit() {
        viewModel?.onDismiss?()
    }
    
    @objc
    private func tappedMinimize() {
        viewModel?.onMinimize?()
    }
    
    @objc
    private func tappedPlayPause(sender: PlayPauseControl) {
        viewModel?.set(mode: sender.mode)
    }
    
    @objc
    private func tappedOverlay() {
        let shouldShow = subviews.contains { $0.alpha == 0 }
        if shouldShow {
            setElements(visible: true)
            timer?.invalidate()
            timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false) { [weak self] (_) in
                self?.setElements(visible: false)
            }
        } else {
            setElements(visible: false)
        }
    }
    
    private func setElements(visible: Bool) {
        [timeline, exitButton, minimizeButton, playPauseControl].forEach { $0.alpha = visible ? 1.0 : 0.0 }
    }
    
    private func bind(with viewModel: PlayerViewModel?) {
        viewModel?.timelineUpdate = { [weak self] (text, ratio) in
            self?.timeline.display(text: text)
            self?.timeline.timeRatio = ratio
        }
        
        viewModel?.bufferUpdate = { [weak self] ratio in
            self?.timeline.bufferRatio = ratio
        }
        
        viewModel?.modeUpdate = { [weak self] mode in
            self?.spinner.isHidden = mode != .waitingToPlayAtSpecifiedRate
            self?.playPauseControl.isHidden = mode == .waitingToPlayAtSpecifiedRate
            switch mode {
            case .paused:
                self?.playPauseControl.mode = .play
            case .playing:
                self?.playPauseControl.mode = .pause
            case .waitingToPlayAtSpecifiedRate:
                self?.spinner.startAnimating()
            @unknown default:
                break
            }
        }
        
        timeline.timelineUpdated = { [weak self] value in
            self?.viewModel?.set(timeRatio: value.newRatio, panning: !value.finished)
        }
    }
}

extension PlayerOverlayView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view != playPauseControl
    }
}
