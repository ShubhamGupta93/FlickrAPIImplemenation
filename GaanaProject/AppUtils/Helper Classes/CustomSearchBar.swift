//
//  CustomSearchBar.swift
//  GaanaProject
//
//  Created by Shubham Gupta on 20/06/20.
//  Copyright © 2020 Shubham Gupta. All rights reserved.
//

import UIKit

class CustomSearchBar: UISearchBar {
    var activityIndicator : UIActivityIndicatorView!
    override func awakeFromNib() {
        activityIndicator = UIActivityIndicatorView(style: .white)
        activityIndicator.hidesWhenStopped = true
        self.addSubview(activityIndicator)
        activityIndicator.frame = self.bounds
        self.textField.layer.borderColor = UIColor.white.cgColor
        self.textField.layer.borderWidth = 0.8
        self.textField.layer.cornerRadius = 10.0
        self.textField.tintColor = UIColor.white
        self.textField.textColor = UIColor.white
        self.textField.placeholder = Constants.searchHere
    }
    
    func startAnimating () {
        activityIndicator.startAnimating()
    }
    func stopAnimating () {
        activityIndicator.stopAnimating()
    }

}

extension CustomSearchBar {
    var textField: UITextField {
        if #available(iOS 13, *) {
            return searchTextField
        } else {
            return self.value(forKey: "_searchField") as? UITextField ?? UITextField()
        }
    }
}
