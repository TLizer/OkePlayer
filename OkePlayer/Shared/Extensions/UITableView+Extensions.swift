//
//  UITableView+Extensions.swift
//  OkePlayer
//
//  Created by Tomasz Lizer on 20/11/2020.
//

import UIKit

extension UITableView {
    func dequeueCell<T: UITableViewCell>(for indexPath: IndexPath, type: T.Type) -> T {
        dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as! T
    }
}
