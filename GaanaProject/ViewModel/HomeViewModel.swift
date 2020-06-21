//
//  HomeViewModel.swift
//  GaanaProject
//
//  Created by Shubham Gupta on 20/06/20.
//  Copyright © 2020 Shubham Gupta. All rights reserved.
//

import Foundation

protocol SearchResultDelegate {
    func reloadImageTable(paging:Paging?, flickrPhotoList:[FlickrPhoto])
    func clearTable()
    func handleError()
}


class HomeViewModel {
    
    var delegate:SearchResultDelegate?
    init() {
        
    }
    func searchForImageWithString(str:String, pageNo:Int = 0)  {
        let urlString = FlickrURL.flickrSearchURLFor(str, page: pageNo) ?? ""
        WebServiceManager.shared.executeQuery(requestPath: urlString, queryParameters: nil, payLoad: nil, headers: nil) { (response, errorMessage) in
            if errorMessage == nil ,let response = response {
                do {
                    let decoder = JSONDecoder()
                    let data = try JSONSerialization.data(withJSONObject: response, options: JSONSerialization.WritingOptions.prettyPrinted)
                    let flickrResponse = try decoder.decode(FlickrResponse.self, from: data)
                    let photosResponse = flickrResponse.photos
                    if(photosResponse?.photo?.count ?? 0 <= 0){
                        OperationQueue.main.addOperation({
                            self.clearDataAndTable()
                            return
                        })
                    }
                    print(response)
                    let totalPages:Int = photosResponse?.pages ?? 0
                    let total:Int = Int(photosResponse?.total ?? "0") ?? 0
                    let currentPage:Int = photosResponse?.page ?? 0
                    let paging = Paging(totalPages: totalPages, elements: Int32(total), currentPage: currentPage)

                    OperationQueue.main.addOperation({
                        if paging.currentPage == 1 {
                            // Reset last data if we are going to load first page
                            self.clearDataAndTable()
                            if totalPages == 0 {
                                UtilityManager.shared.showToast(message: Constants.noDataFound)
                            }
                        }
                        self.delegate?.reloadImageTable(paging: paging, flickrPhotoList: photosResponse?.photo ?? [])

                    })
                } catch {
                    print("error:\(error)")
                }
            } else {
                self.delegate?.handleError()
                UtilityManager.shared.showToast(message: errorMessage ?? Constants.genericError)
            }
        }
        
    }
    
    private func clearDataAndTable() {
        // Reset last data if we are going to load first page
        ImageDownloadManager.shared.cancelAll()
        self.delegate?.clearTable()
    }
    
}
