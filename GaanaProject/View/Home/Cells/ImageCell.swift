//
//  ImageCell.swift
//  GaanaProject
//
//  Created by Shubham Gupta on 20/06/20.
//  Copyright © 2020 Shubham Gupta. All rights reserved.
//

import UIKit

class ImageCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}

extension ImageCell {
    static func nib() -> UINib {
        return UINib(nibName: "ImageCell", bundle: Bundle(for: ImageCell.self))
    }
    
    static func reuseIdentifier() -> String {
        return "ImageCell"
    }
}

