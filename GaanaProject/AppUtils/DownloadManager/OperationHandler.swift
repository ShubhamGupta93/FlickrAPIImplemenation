//
//  OperationHandler.swift
//  GaanaProject
//
//  Created by Shubham Gupta on 20/06/20.
//  Copyright © 2020 Shubham Gupta. All rights reserved.
//

import Foundation
import UIKit

class MyOperation: Operation {
    
    
    //*********** Adding extra properties to recognise which Image and for which index Path***********
    var imageUrl:URL!
    var indexPath:IndexPath?
    
    var downloadHandler: ImageDownloadHandler?
    
    override var isAsynchronous: Bool {
        get {
            return  true
        }
    }
    
    private var _executing = false {
        willSet {
            willChangeValue(forKey: "isExecuting")
        }
        didSet {
            didChangeValue(forKey: "isExecuting")
        }
    }
    
    override var isExecuting: Bool {
        return _executing
    }
    
    private var _finished = false {
        willSet {
            willChangeValue(forKey: "isFinished")
        }
        
        didSet {
            didChangeValue(forKey: "isFinished")
        }
    }
    
    override var isFinished: Bool {
        return _finished
    }
    
    func executing(_ executing: Bool) {
        _executing = executing
    }
    
    func finish(_ finished: Bool) {
        _finished = finished
    }
    
    required init (url: URL, indexPath: IndexPath?) {
        super.init()
        self.imageUrl = url
        self.indexPath = indexPath
    }
    
    override func main() {
        
        guard isCancelled == false else {
            finish(true)
            return
        }
        self.executing(true)
        //Asynchronous logic (eg: n/w calls) with callback
        self.downloadImageFromUrl()
    }
    
    func downloadImageFromUrl() {
        let newSession = URLSession.shared
        let downloadTask = newSession.downloadTask(with: self.imageUrl) { (location, response, error) in
            if let locationUrl = location, let data = try? Data(contentsOf: locationUrl){
                let image = UIImage(data: data)
                self.downloadHandler?(image,self.imageUrl, self.indexPath,error)
            }
            self.finish(true)
            self.executing(false)
        }
        downloadTask.resume()
    }
    
    
    

}
