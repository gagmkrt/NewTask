//
//  UserTableViewCell.swift
//  Task1
//
//  Created by Gag Mkrtchyan on 18.02.21.
//

import UIKit
import Kingfisher

class UserTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userFullName: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    
    func setItems(item: ResultModel) {
        userFullName.text = item.name?.fullName
        userEmail.text = item.email
        
        if let cover = item.photoUrl {
            self.userImage.kf.setImage(with: cover)
        }
    }
}
