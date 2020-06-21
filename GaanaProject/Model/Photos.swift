//
//  Photos.swift
//  GaanaProject
//
//  Created by Shubham Gupta on 21/06/20.
//  Copyright © 2020 Shubham Gupta. All rights reserved.
//

import Foundation

class Photos: Codable {
    var page: Int?
    var pages: Int?
    var total: String?
    var photo: [FlickrPhoto]?
    
}
