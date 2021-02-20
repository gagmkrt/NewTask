//
//  Extensions.swift
//  Task1
//
//  Created by Gag Mkrtchyan on 18.02.21.
//

import UIKit

extension UITableViewCell {
    class func registerIn(_ tableView: UITableView) {
        let identifier = self.identifier
        let nib = UINib(nibName: identifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: identifier)
    }
}

extension UIView {
    class var identifier: String {
        return String(describing: self)
    }
}
