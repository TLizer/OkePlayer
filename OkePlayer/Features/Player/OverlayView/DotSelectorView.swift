//
//  DotSelectorView.swift
//  OkePlayer
//
//  Created by Tomasz Lizer on 22/11/2020.
//

import UIKit

protocol TimelineSelectorViewModel {
    var timelineUpdate: ((Double) -> Void)? { get set }
    var bufferUpdate: ((Double) -> Void)? { get set }
    func update(timeRatio: Double)
}

class TimelineSelectorView: UIControl {
    private static var selectorSize: CGFloat = 10
    private static var activeSelectorSize: CGFloat = selectorSize + 20
    
    private let bufferView = UIView.with(color: UIColor.white.withAlphaComponent(0.4))
    private let valueView = UIView.with(color: UIColor.red)
    private let selectorView = DotSelectorView()
    
    var viewModel: TimelineSelectorViewModel?
    
    private var bufferRatio: Double = 0
    private var timeRatio: Double = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        setupGestures()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = UIColor.white.withAlphaComponent(0.2)
        
        addSubviews([bufferView, valueView, selectorView])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    private func setupGestures() {
        let panGesture = UIPanGestureRecognizer()
        panGesture.addTarget(self, action: #selector(panning))
        panGesture.delegate = self
        selectorView.addGestureRecognizer(panGesture)
        
        let tapGesture = UIGestureRecognizer()
        tapGesture.addTarget(self, action: #selector(tapped))
        tapGesture.delegate = self
        selectorView.addGestureRecognizer(tapGesture)
    }
    
    @objc
    private func tapped(recognizer: UIGestureRecognizer) {
        print("TAPPED, state: \(String(describing: recognizer.state))")
        switch recognizer.state {
        case .possible:
            break
        default:
            break
        }
    }
    
    @objc
    private func panning(recognizer: UIPanGestureRecognizer) {
        print("panning, state: \(String(reflecting: recognizer.state))")
        switch recognizer.state {
        case .began:
            selectorView.dotSize = Self.activeSelectorSize
        case .changed:
            break
        default:
            selectorView.dotSize = Self.selectorSize
        }
    }
}

extension TimelineSelectorView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
}

class DotSelectorView: UIView {
    private let dotView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.red
        return view
    }()
    
    var dotSize: CGFloat = 10 {
        didSet {
            guard oldValue != dotSize else { return }
            updateDotLayout()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 40, height: 40)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(dotView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateDotLayout()
    }
    
    private func updateDotLayout() {
        dotView.frame.size = CGSize(width: dotSize, height: dotSize)
        dotView.center = CGPoint(x: self.frame.width / 2.0, y: self.frame.height / 2.0)
        dotView.layer.cornerRadius = dotSize / 2.0
    }
}
