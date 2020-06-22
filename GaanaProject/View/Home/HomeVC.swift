//
//  HomeVC.swift
//  GaanaProject
//
//  Created by Shubham Gupta on 20/06/20.
//  Copyright © 2020 Shubham Gupta. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: CustomSearchBar!
    
    private var searchResult = ImageSearchResult()
    private var paging : Paging?
    private var footerView:FooterCell?
    private var isLoadingPhoto: Bool = false // Flag if currently loading Photos

    //******* Lazy Loading Will initialize Opeject if we need it ****************
    lazy var viewModel : HomeViewModel = {
        let viewModel = HomeViewModel()
        return viewModel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.delegate = self
        self.collectionView.register(ImageCell.nib(), forCellWithReuseIdentifier: ImageCell.reuseIdentifier())
        self.collectionView.register(FooterCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: FooterCell.reuseIdentifier())
    }
    
    override func viewWillLayoutSubviews() {
        self.setUI()
    }
    
    private func setUI(){
        self.navigationController?.setNavigationBar()
        self.navigationItem.setNavigationBarItem(titleString: Constants.navigationTitle, hideBackButton: true)
        let activityIndicator = UIActivityIndicatorView(style: .gray)
        activityIndicator.hidesWhenStopped = true
        searchBar.addSubview(activityIndicator)
        activityIndicator.frame = searchBar.bounds
    }
    
    @IBAction func searchButtonAction(_ sender: Any) {
        searchBarSearchButtonClicked(searchBar)
    }
}

extension HomeVC: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let customSearchBar = searchBar as? CustomSearchBar else {
            return
        }
        customSearchBar.textField.resignFirstResponder()
        paging = nil
        isLoadingPhoto = true
        guard let searchText = customSearchBar.textField.text, searchText.count > 0 else {
            ImageDownloadManager.shared.cancelAll()
            self.searchResult.flickrPhotoList.removeAll()
            self.collectionView?.reloadData()
            self.isLoadingPhoto = false
            return
        }
        customSearchBar.startAnimating()
        viewModel.searchForImageWithString(str: searchText, pageNo: 1)
    }
}

extension HomeVC: SearchResultDelegate {
    func clearTable() {
        searchBar.stopAnimating()
        searchResult.flickrPhotoList.removeAll()
        collectionView.reloadData()
        isLoadingPhoto = false
    }
    
    func reloadImageTable(paging: Paging?, flickrPhotoList: [FlickrPhoto]) {
        searchBar.stopAnimating()
        self.searchResult.flickrPhotoList.append(contentsOf: flickrPhotoList)
        self.paging = paging
        self.collectionView?.reloadData()
        self.isLoadingPhoto = false
    }
    
    func handleError() {
        searchBar.stopAnimating()
        footerView?.stopAnimating()
        self.isLoadingPhoto = false
    }
}


extension HomeVC:UICollectionViewDelegate,UICollectionViewDataSource{
    
    
    //********** Collection View Delegate Methods *******************************
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchResult.flickrPhotoList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let imageCell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.reuseIdentifier(), for: indexPath) as? ImageCell else {
          return UICollectionViewCell()
        }
        imageCell.imageView.isUserInteractionEnabled = true
        return imageCell
        
    }
    
     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
//        let rectOfCell = collectionView.cellForItem(at: indexPath)
//        let rectOfCell= collectionView.rectForRowAtIndexPath(indexPath)
        
        let  attributes = collectionView.layoutAttributesForItem(at: indexPath)
        let cellRect:CGRect = attributes?.frame ?? CGRect(x: 0.0, y: 0.0, width: 0.0, height: 0.0)
        
        let rectOfCellInSuperview = collectionView.convert(cellRect, to: collectionView.superview)

        
        print(rectOfCellInSuperview.origin.x)
        print(rectOfCellInSuperview.origin.y)
        
        let detailView = DetailVC()
        detailView.photo = searchResult.flickrPhotoList[indexPath.item]
        detailView.initialRect = rectOfCellInSuperview
        self.navigationController?.pushViewController(detailView, animated: false)
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if self.searchResult.flickrPhotoList.count <= indexPath.item {
            return
        }
        let lastRowIndex = collectionView.numberOfItems(inSection: 0) - 1
        if indexPath.item == lastRowIndex && paging != nil {
            handleLoadingMorePhotos()
        }
        let image = self.searchResult.flickrPhotoList[indexPath.item]
        guard let imageCell = cell as? ImageCell else {
            return
        }
        imageCell.imageView.image = UIImage(named: "placeholder")
        ImageDownloadManager.shared.downloadImage(image, indexPath: indexPath) { (image, url, indexPathNew, error) in
            DispatchQueue.main.async {
                if let indexPathNew = indexPathNew {
                    if indexPathNew == indexPath {
                        imageCell.imageView.image = image
                    } else if let cell = collectionView.cellForItem(at: indexPathNew) as? ImageCell {
                            cell.imageView.image = image
                    }
                }
            }
            
        }
        
    }
    
    
    //******** IF cell is not in the visible screen Decrease Priority *************************
    
     func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if self.searchResult.flickrPhotoList.count <= indexPath.item {
            return
        }
        ImageDownloadManager.shared.slowDownImageDownloadTaskfor(searchResult.flickrPhotoList[indexPath.item])
    }
    
}



extension HomeVC: UICollectionViewDelegateFlowLayout {
    
    //************** Setting Flow layout like pedding margin cell size (Width height) *******************
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSide = ((self.collectionView.frame.size.width - (Constants.paddingBetweenCells * (Constants.itemsInRow + 1))) / Constants.itemsInRow)
        return CGSize(width: CGFloat(Int(cellSide)), height: CGFloat(Int(cellSide)))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        if searchResult.flickrPhotoList.count <= 0 || self.paging?.currentPage == self.paging?.totalPages {
            return CGSize(width: 0, height: 0)
        }
        return CGSize(width: collectionView.contentSize.width-2*Constants.paddingBetweenCells, height: 50)
        
    }
    
    //******************* Setting Footer here with activity indicator for showing more loading images *******************
    
     func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            self.footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: FooterCell.reuseIdentifier(), for: indexPath) as? FooterCell
            if let footerView = self.footerView {
                return footerView
            }
        }
        return UICollectionReusableView()
    }
    
    
    //******************* For Start and Stop indicator logic we willsave Footer object to Local Property *************

     func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        
        if elementKind == UICollectionView.elementKindSectionFooter && isLoadingPhoto {
            self.footerView?.startAnimation()
        }
    }
     func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        
        if elementKind == UICollectionView.elementKindSectionFooter {
            self.footerView?.stopAnimating()
        }
    }
    
    private func handleLoadingMorePhotos() {
        guard let searchText = searchBar.textField.text, searchText.count > 0 else {
            return
        }
        if let currentPage = paging?.currentPage, let totalPages = paging?.totalPages, !isLoadingPhoto && currentPage < totalPages {
            isLoadingPhoto = true
            viewModel.searchForImageWithString(str: searchText, pageNo: currentPage + 1)
        }
    }

}
