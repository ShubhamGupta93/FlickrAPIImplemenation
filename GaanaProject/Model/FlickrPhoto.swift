//
//  FlickrPhoto.swift
//  GaanaProject
//
//  Created by Shubham Gupta on 20/06/20.
//  Copyright © 2020 Shubham Gupta. All rights reserved.
//

import Foundation


class FlickrPhoto: Codable {
    var photoID: String
    var farm: Int
    var server: String
    var secret: String

    enum CodingKeys: String, CodingKey {
        case photoID = "id"
        case farm = "farm"
        case server = "server"
        case secret = "secret"
    }
    
    func flickrImageURL(_ size:String = "s") -> URL? {
        if let url =  URL(string: "https://farm\(farm).staticflickr.com/\(server)/\(photoID)_\(secret)_\(size).jpg") {
            return url
        }
        return nil
    }
}

func == (lhs: FlickrPhoto, rhs: FlickrPhoto) -> Bool {
    return lhs.photoID == rhs.photoID
}
