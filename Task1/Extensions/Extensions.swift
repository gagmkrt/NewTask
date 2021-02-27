//
//  Extensions.swift
//  Task1
//
//  Created by Gag Mkrtchyan on 18.02.21.
//

import UIKit
import Foundation

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


extension Encodable {
    // Convert Model to Plist
    var toPlist: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
    
    var toData: Data? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return data
    }

}

