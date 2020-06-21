//
//  FooterCell.swift
//  GaanaProject
//
//  Created by Shubham Gupta on 20/06/20.
//  Copyright © 2020 Shubham Gupta. All rights reserved.
//

import UIKit

class FooterCell:UICollectionReusableView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        activityIndicator = UIActivityIndicatorView(style: .white)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.frame = self.bounds
        self.addSubview(activityIndicator)
        self.backgroundColor = UIColor.black
       // Customize here

    }

    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)

    }
    
    var activityIndicator : UIActivityIndicatorView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }
    
    func startAnimation(){
        self.activityIndicator.startAnimating()
    }
    
    func stopAnimating(){
        self.activityIndicator.stopAnimating()
    }
}

extension FooterCell {
    static func nib() -> UINib {
        return UINib(nibName: "FooterCell", bundle: Bundle(for: FooterCell.self))
    }
    
    static func reuseIdentifier() -> String {
        return "FooterCell"
    }
}
