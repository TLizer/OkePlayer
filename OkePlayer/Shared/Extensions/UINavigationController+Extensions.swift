//
//  UINavigationController+Extensions.swift
//  OkePlayer
//
//  Created by Tomasz Lizer on 21/11/2020.
//

import UIKit

extension UINavigationController: DisplayContainer {
    func display(viewController: UIViewController) {
        pushViewController(viewController, animated: true)
    }
}
