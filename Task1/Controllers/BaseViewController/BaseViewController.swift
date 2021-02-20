//
//  BaseViewController.swift
//  Task1
//
//  Created by Gag Mkrtchyan on 18.02.21.
//

import UIKit

class BaseViewController: UIViewController {
    
    let indicator = UIActivityIndicatorView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupIndicator()
    }
    
    func setupIndicator() {
        indicator.center = self.view.center
        indicator.hidesWhenStopped = true
        view.addSubview(indicator)
        indicator.startAnimating()
    }
   
}
