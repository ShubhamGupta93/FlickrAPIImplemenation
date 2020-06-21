//
//  DetailVC.swift
//  GaanaProject
//
//  Created by Shubham Gupta on 20/06/20.
//  Copyright © 2020 Shubham Gupta. All rights reserved.
//

import UIKit

class DetailVC: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    private var imageViewFrame = CGRect()
    var initialRect: CGRect!
    var photo: FlickrPhoto!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadDownloadedSmall()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBar()
        self.navigationItem.setNavigationBarItem(titleString: Constants.navigationTitle, hideBackButton: true)
        
        let backButton = UIBarButtonItem(image: UIImage(named: "backIcon"), style: .plain, target: self, action: #selector(back(sender:)))
        backButton.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = backButton
    }

    
    @objc func back(sender: UIBarButtonItem) {
        UIView.animate(withDuration: 0.3, animations: {
            self.imageView.frame = self.initialRect
        }) { (sucess) in
            let transition = CATransition()
            transition.duration = 0.2
            transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
            transition.type = CATransitionType.fade
            self.navigationController?.view.layer.add(transition, forKey: nil)
            _ = self.navigationController?.popViewController(animated: false)
            ImageDownloadManager.shared.cancelDownloadingImage(self.photo)
        }
    }
     
     override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.imageViewFrame = self.imageView.frame
        guard let rect = self.initialRect else {
            return
        }
        self.imageView.frame = rect
        self.animation()
        self.getHigherResolutionImage()

     }
     
     
     
     private func animation() {
        UIView.animate(withDuration: 0.5, delay: 0.1, options: UIView.AnimationOptions.allowUserInteraction, animations: {
             self.imageView.frame = self.imageViewFrame

         }) { (sucess) in
            self.imageView.frame = self.imageViewFrame
         }
    }
     
     private func loadDownloadedSmall(){
        self.imageView.image = UIImage(named: "placeholder")
         ImageDownloadManager.shared.downloadImage(photo, indexPath: nil, size: "s") { (image, url, indexpath, error) in
             DispatchQueue.main.async {
                 self.imageView.image = image
             }
             
         }
     }

     private func getHigherResolutionImage(){
         ImageDownloadManager.shared.downloadImage(photo, indexPath: nil, size: "m") { (image, url, indexpath, error) in
            DispatchQueue.main.async {
             guard let imag: UIImage = image else{
                 return
             }
             self.imageView.image = imag
            }
         }
     }
}
