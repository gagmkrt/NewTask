//
//  Model.swift
//  Task1
//
//  Created by Gag Mkrtchyan on 18.02.21.
//

import Foundation

struct ResponseModel<T: Codable>: Codable {
    var results: T?
}

struct ResultModel: Codable {
    var id: UserId?
    var email: String?
    var name: UserName?
    var picture: Picture?
    var location: UserLocation?
    var phone: String?
    var country: String?
    
    var photoUrl: URL? {
        return self.picture?.thumbnail != nil ? URL(string: (picture?.thumbnail)!) : nil
    }
}

struct UserId: Codable {
    var name: String?
    var value: String?
}

struct UserName: Codable {
    var first: String
    var last: String
    var title: String
    
    var fullName: String {
        return title + " " + first + " " + last
    }
}

struct Picture: Codable {
    var large: String
    var medium: String
    var thumbnail: String
}

struct UserLocation: Codable {
    var city: String
    var coordinates: Coordinates?
}

struct Coordinates: Codable {
    var latitude: String
    var longitude: String
}
