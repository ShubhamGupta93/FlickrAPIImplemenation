//
//  FlickrURL.swift
//  GaanaProject
//
//  Created by Shubham Gupta on 20/06/20.
//  Copyright © 2020 Shubham Gupta. All rights reserved.
//

import Foundation

class FlickrURL {
    
    static let apiKey = "751e5fac10c901b86ab6cf458b93e684"
    class func flickrSearchURLFor(_ searchString:String, page: Int = 1) -> String? {
        
        guard let escapedTerm = searchString.addingPercentEncoding(withAllowedCharacters: CharacterSet.alphanumerics) else {
            return nil
        }
        
        let URLString = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(apiKey)&text=\(escapedTerm)&per_page=20&format=json&nojsoncallback=1&page=\(page)"
        
        guard let _ = URL(string:URLString) else {
            return nil
        }
        
        return URLString
    }
}
