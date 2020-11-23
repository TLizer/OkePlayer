//
//  TimelineView.swift
//  OkePlayer
//
//  Created by Tomasz Lizer on 22/11/2020.
//

import UIKit

class TimelineView: UIView {
    typealias TimelineUpdate = (newRatio: Double, finished: Bool)
    
    private static var timelineHeight: CGFloat = 5
    private static var labelPading: CGFloat = 12
    private static var selectorSize: CGFloat = 10
    private static var activeSelectorSize: CGFloat = selectorSize + 12
    
    private let timeLabel = UILabel.with(style: .timelineIndicator)
    private let timelineBackground = indicator(with: UIColor.white.withAlphaComponent(0.2))
    private let timelineBufferView = indicator(with: UIColor.white.withAlphaComponent(0.5))
    private let timelineValueView = indicator(with: UIColor.red)
    private let selectorView = DotSelectorView()
    
    private var previousSize = CGSize.zero
    
    var bufferRatio: Double = 0 {
        didSet { updateBufferFrame() }
    }
    var timeRatio: Double = 0 {
        didSet { updateTimeFrame() }
    }
    
    var timelineUpdated: ((TimelineUpdate) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        setupGestures()
        
        bufferRatio = 0.5
        timeRatio = 0.2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func display(text: String?) {
        timeLabel.text = text
    }
    
    // MARK: - Pan gesture
    private func setupGestures() {
        let panGesture = UIPanGestureRecognizer()
        panGesture.addTarget(self, action: #selector(panning))
        selectorView.addGestureRecognizer(panGesture)
    }
    
    @objc
    private func panning(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            selectorView.dotSize = Self.activeSelectorSize
        case .changed:
            let newWidth = recognizer.translation(in: self).x + timelineValueView.frame.size.width
            let clamped = newWidth.clamped(minValue: Self.selectorSize / 2.0, maxValue: bounds.width - Self.selectorSize / 2.0)
            timeRatio = timelineRatio(for: clamped)
            timelineUpdated?((timeRatio, false))
            recognizer.setTranslation(.zero, in: self)
        default:
            selectorView.dotSize = Self.selectorSize
            timelineUpdated?((timeRatio, true))
        }
    }
    
    
    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        guard frame.size != previousSize else { return }
        previousSize = frame.size
        
        updateTimeFrame()
        updateBufferFrame()
    }
    
    private func updateTimeFrame() {
        timelineValueView.frame = CGRect(
            x: 0,
            y: timelineBackground.frame.minY,
            width: timelineWidthFor(ratio: timeRatio),
            height: Self.timelineHeight)
    }
    
    private func updateBufferFrame() {
        timelineBufferView.frame = CGRect(
            x: timelineValueView.frame.maxX,
            y: timelineBackground.frame.minY,
            width: timelineWidthFor(ratio: bufferRatio) - timelineValueView.frame.width,
            height: Self.timelineHeight)
    }
    
    private func setupUI() {
        addSubviews([timeLabel, timelineBackground, timelineBufferView, timelineValueView, selectorView])
        
        [timeLabel, timelineBackground, selectorView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        timeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: Self.labelPading).isActive = true
        timeLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: Self.labelPading).isActive = true
        
        timelineBackground.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: Self.labelPading).isActive = true
        timelineBackground.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -Self.labelPading).isActive = true
        timelineBackground.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        timelineBackground.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        timelineBackground.heightAnchor.constraint(equalToConstant: Self.timelineHeight).isActive = true
        
        selectorView.centerYAnchor.constraint(equalTo: timelineValueView.centerYAnchor).isActive = true
        selectorView.centerXAnchor.constraint(equalTo: timelineValueView.rightAnchor).isActive = true
        
        selectorView.dotSize = Self.selectorSize
    }
    
    // MARK: - Helpers
    private func timelineWidthFor(ratio: Double) -> CGFloat {
        let fullWidth = self.frame.width - Self.selectorSize
        let ratioWidth = fullWidth * CGFloat(ratio.clamped(minValue: 0.0, maxValue: 1.0))
        return ratioWidth + Self.selectorSize / 2.0
    }
    
    private func setWidth(for ratio: Double, in view: UIView) {
        view.frame.size.width = timelineWidthFor(ratio: ratio)
    }
    
    private func timelineRatio(for width: CGFloat) -> Double {
        let fullWidth = self.frame.width - Self.selectorSize
        let timelineWidth = width - Self.selectorSize / 2.0
        let ratio = Double(timelineWidth / fullWidth)
        return ratio.clamped(minValue: 0.0, maxValue: 1.0)
    }
    
    private static func indicator(with color: UIColor) -> UIView {
        let view = UIView()
        view.backgroundColor = color
        return view
    }
}
