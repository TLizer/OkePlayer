//
//  UIView+Extensions.swift
//  OkePlayer
//
//  Created by Tomasz Lizer on 21/11/2020.
//

import UIKit

extension UIView {
    func embed(in view: UIView, insets: UIEdgeInsets = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(self)
        self.topAnchor.constraint(equalTo: view.topAnchor, constant: insets.top).isActive = true
        self.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -insets.bottom).isActive = true
        self.leftAnchor.constraint(equalTo: view.leftAnchor, constant: insets.left).isActive = true
        self.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -insets.right).isActive = true
    }
    
    func embed(in layoutGuide: UILayoutGuide, insets: UIEdgeInsets = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        self.topAnchor.constraint(equalTo: layoutGuide.topAnchor, constant: insets.top).isActive = true
        self.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor, constant: -insets.bottom).isActive = true
        self.leftAnchor.constraint(equalTo: layoutGuide.leftAnchor, constant: insets.left).isActive = true
        self.rightAnchor.constraint(equalTo: layoutGuide.rightAnchor, constant: -insets.right).isActive = true
    }
    
    func pinToCenter(in view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        self.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        self.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    func addSubviews(_ views: [UIView]) {
        views.forEach { view in
            addSubview(view)
        }
    }
    
    static func with(color: UIColor) -> UIView {
        let view = UIView()
        view.backgroundColor = color
        return view
    }
}
