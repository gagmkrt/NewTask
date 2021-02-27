//
//  RealmModel.swift
//  Task1
//
//  Created by Gag Mkrtchyan on 26.02.21.
//

import Foundation
import RealmSwift

class Info: Object {
    @objc dynamic var name = ""
    @objc dynamic var email = ""
    @objc dynamic var photoData = ""
}

class ItemList: Object {
   let items = List<Info>()
}
