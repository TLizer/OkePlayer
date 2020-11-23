//
//  PlayerViewModel.swift
//  OkePlayer
//
//  Created by Tomasz Lizer on 22/11/2020.
//

import AVFoundation

class PlayerViewModel {
    @WrappedUserDefault
    private var savedTimestamp: Double
    private let playerItem: AVPlayerItem
    private let id: String
    let player = AVPlayer()
    var onDismiss: (() -> Void)?
    var onMinimize: (() -> Void)?
    
    private var shouldRestore = false
    private var restored = false {
        didSet { updateMode() }
    }
    private var observers: [NSKeyValueObservation] = []
    private var timeUpdater: Any?
    private var duration: CMTime? {
        didSet {
            guard oldValue != duration else { return }
            updateTimeline(time: player.currentTime())
        }
    }
    
    var timelineUpdate: ((String, Double) -> Void)? {
        didSet { updateTimeline(time: player.currentTime()) }
    }
    
    var bufferUpdate: ((Double) -> Void)?
    
    var modeUpdate: ((AVPlayer.TimeControlStatus) -> Void)? {
        didSet { updateMode() }
    }
    
    var visibilityUpdate: ((Bool) -> Void)?
    
    var canRestore: Bool {
        savedTimestamp != 0.0
    }
    
    init(playerItem: AVPlayerItem, id: String) {
        self.playerItem = playerItem
        self.id = id
        self._savedTimestamp = WrappedUserDefault("Saved_Timestamp_\(id)", defaultValue: 0.0)
        
        self.setupObservers()
    }
    
    deinit {
        print("DEBUG -DEINIT VIEWMODEL")
        setTimeUpdate(start: false)
        persistCurrentTime()
    }
    
    func set(mode: PlayPauseControl.Mode) {
        switch mode {
        case .play:
            player.play()
        case .pause:
            player.pause()
        }
        
        setTimeUpdate(start: mode == .play)
    }
    
    func set(timeRatio ratio: Double, panning: Bool) {
        guard let duration = self.duration else { return }
        let value = CMTimeValue(Double(duration.value) * ratio)
        let time = CMTime(value: value, timescale: duration.timescale)
        if !panning {
            player.seek(to: time) { _ in
                self.setTimeUpdate(start: true)
            }
        } else {
            setTimeUpdate(start: false)
        }
        
        updateTimeline(time: time)
    }
    
    func setupPlayer() {
        player.replaceCurrentItem(with: playerItem)
    }
    
    func startPlayer(startFormBeggining: Bool) {
        if startFormBeggining {
            restored = true
            set(mode: .play)
        } else {
            shouldRestore = true
            restoreTimeline()
        }
    }
    
    func persistCurrentTime() {
        savedTimestamp = player.currentTime().seconds
    }
    
    private func setupObservers() {
        let durationObserver = playerItem.observe(\.duration, options: .new) { [weak self] (item, change) in
            if let duration = change.newValue { self?.duration = duration }
        }
        
        let bufferObserver = playerItem.observe(\.loadedTimeRanges) { [weak self] (item, change) in
            let buffer = item.loadedTimeRanges
                .map { $0.timeRangeValue }
                .first { $0.containsTime(self?.player.currentTime() ?? .zero) }?.end ?? .zero
            guard let duration = self?.duration, duration.value != 0 else {
                self?.bufferUpdate?(0)
                return
            }
            self?.bufferUpdate?(buffer.seconds / duration.seconds)
        }
        
        let statusObserver = playerItem.observe(\.status) { [weak self] (item, change) in
            guard item.status == .readyToPlay else { return }
            self?.restoreTimeline()
        }
        
        let playStateObserver = player.observe(\.timeControlStatus) { [weak self] _, _ in self?.updateMode() }
        
        observers.append(contentsOf: [durationObserver, bufferObserver, statusObserver, playStateObserver])
    }
    
    private func setTimeUpdate(start: Bool) {
        if start, timeUpdater == nil {
            let interval = CMTime(value: 1, timescale: 60)
            timeUpdater = player.addPeriodicTimeObserver(forInterval: interval, queue: nil) { [weak self] (time) in
                self?.updateTimeline(time: time)
            }
        } else if !start, timeUpdater != nil {
            timeUpdater.map { player.removeTimeObserver($0) }
            timeUpdater = nil
        }
    }
    
    private func updateMode() {
        guard restored else { return }
        modeUpdate?(player.timeControlStatus)
    }
    
    private func updateTimeline(time: CMTime) {
        guard let duration = self.duration, duration.value != 0 else {
            timelineUpdate?("-", 0)
            return
        }
        let ratio = time.seconds / duration.seconds
        
        timelineUpdate?("\(time.seconds.hourMinutesSeconds())/\(duration.seconds.hourMinutesSeconds())", ratio)
    }
    
    private func restoreTimeline() {
        guard !restored, shouldRestore else { return }
        let savedTime = CMTime(seconds: savedTimestamp, preferredTimescale: .init(60))
        
        self.player.seek(to: savedTime) { _ in
            let currentTime = self.player.currentTime()
            self.updateTimeline(time: currentTime)
            self.set(mode: .play)
            self.restored = true
        }
    }
}
