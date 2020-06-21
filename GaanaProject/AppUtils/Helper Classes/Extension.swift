//
//  Extension.swift
//  GaanaProject
//
//  Created by Shubham Gupta on 20/06/20.
//  Copyright © 2020 Shubham Gupta. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationController {
    func setNavigationBar() {
        self.navigationBar.isTranslucent = false
        self.navigationBar.barTintColor = UIColor(red: 50.0/255.0, green: 50.0/255.0, blue: 50.0/255.0, alpha: 1.0)
        self.navigationBar.tintColor = UIColor.white
        self.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
}


extension UINavigationItem {
    func setNavigationBarItem(titleString:String,hideBackButton:Bool = false) {
        self.hidesBackButton = hideBackButton
        self.title = titleString
    }
}


