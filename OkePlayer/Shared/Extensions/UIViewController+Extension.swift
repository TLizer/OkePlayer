//
//  UIViewController+Extension.swift
//  OkePlayer
//
//  Created by Tomasz Lizer on 23/11/2020.
//

import UIKit

extension UIViewController {
    func displayAcceptPopup(title: String = "", message: String, callback: @escaping (Bool) -> Void) {
        let popup = UIAlertController(title: title, message: message, preferredStyle: .alert)
        popup.addAction(UIAlertAction(title: "CANCEL", style: .cancel, handler: { [weak popup] action in
            callback(false)
            popup?.dismiss(animated: true)
        }))
        popup.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak popup] _ in
            callback(true)
            popup?.dismiss(animated: true)
        }))
        present(popup, animated: true)
    }
    
    func displayInfoPopup(title: String = "", message: String, callback: @escaping () -> Void) {
        let popup = UIAlertController(title: title, message: message, preferredStyle: .alert)
        popup.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak popup] _ in
            callback()
            popup?.dismiss(animated: true)
        }))
        present(popup, animated: true)
    }
}
