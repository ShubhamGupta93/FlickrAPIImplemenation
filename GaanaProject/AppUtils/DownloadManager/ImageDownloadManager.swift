//
//  DownloadManager.swift
//  GaanaProject
//
//  Created by Shubham Gupta on 20/06/20.
//  Copyright © 2020 Shubham Gupta. All rights reserved.
//

import Foundation
import UIKit

typealias ImageDownloadHandler = (_ image: UIImage?, _ url: URL, _ indexPath: IndexPath?, _ error: Error?) -> Void

class ImageDownloadManager{
    
    static let shared = ImageDownloadManager()
    private var completionHandler: ImageDownloadHandler?
    let cache = NSCache<NSString, UIImage>()

    private init (){}
    
    lazy var imageDownloadQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.name = "Gaana.imageDownloadqueue"
        queue.qualityOfService = .userInteractive
        return queue
    }()
    
    
    func downloadImage(_ flickrPhoto: FlickrPhoto, indexPath: IndexPath?, size: String = "s", handler: @escaping ImageDownloadHandler) {
        self.completionHandler = handler
        guard let url = flickrPhoto.flickrImageURL(size) else {
            return
        }
        if let cachedImage = cache.object(forKey: url.absoluteString as NSString) {
            /* check for the cached image for url, if YES then return the cached image */
            self.completionHandler?(cachedImage, url, indexPath, nil)
        } else {
            /* check if there is a download task that is currently downloading the same image. */
            if let operations = (imageDownloadQueue.operations as? [MyOperation])?.filter({$0.imageUrl.absoluteString == url.absoluteString && $0.isFinished == false && $0.isExecuting == true }), let operation = operations.first {
                print("Increase the priority for \(url)")
                operation.queuePriority = .veryHigh
            }else {
                /* create a new task to download the image.  */
                let operation = MyOperation(url: url, indexPath: indexPath)
                operation.queuePriority = .veryHigh
                operation.downloadHandler = { (image, url, indexPath, error) in
                    if let newImage = image {
                        self.cache.setObject(newImage, forKey: url.absoluteString as NSString)
                    }
                    self.completionHandler?(image, url, indexPath, error)
                }
                imageDownloadQueue.addOperation(operation)
            }
        }
    }
    
    
    
    
    //******************* If we think there is least chance or the image download process can take more time we will change the priority***
    //******************* so that the images or indexes currently shown up will get more resorces to download ******************************
    
    func slowDownImageDownloadTaskfor (_ flickrPhoto: FlickrPhoto) {
        guard let url = flickrPhoto.flickrImageURL() else {
            return
        }
        if let operations = (imageDownloadQueue.operations as? [MyOperation])?.filter({$0.imageUrl.absoluteString == url.absoluteString && $0.isFinished == false && $0.isExecuting == true }), let operation = operations.first {
            print("Reduce the priority for \(url)")
            operation.queuePriority = .low
        }
    }
    
    
    func cancelDownloadingImage(_ photo: FlickrPhoto){
        guard let url = photo.flickrImageURL() else {
            return
        }
        if let operations = (imageDownloadQueue.operations as? [MyOperation])?.filter({$0.imageUrl.absoluteString == url.absoluteString && $0.isFinished == false && $0.isExecuting == true }), let operation = operations.first {
            print("Reduce the priority for \(url)")
            operation.cancel()
        }
    }
    
    
    
    func cancelAll() {
        imageDownloadQueue.cancelAllOperations()
    }
    
}
