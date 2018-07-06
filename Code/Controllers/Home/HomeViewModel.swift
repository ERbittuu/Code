//
//  HomeViewModel.swift
//  Code
//
//  Created by Utsav Patel on 7/2/18.
//  Copyright © 2018 erbittuu. All rights reserved.
//

import Foundation

class HomeViewModel {
    
    private var photoResponse: PhotoResponse?
    
    private var fetchingData: Bool = false
    
    private var cellViewModels: [CellViewModel] = [CellViewModel]()

    var isIntitialLoading: Bool = false {
        didSet {
            doOnMain {
                self.updateLoadingStatus?()
            }
        }
    }
    
    var alertMessage: String? {
        didSet {
            doOnMain {
                self.showAlertClosure?()
            }
        }
    }
    
    var numberOfCells: Int {
        return cellViewModels.count
    }
        
    var selectedPhoto: Media?

    var reloadTableViewClosure: (()->())?
    var showAlertClosure: (()->())?
    var updateLoadingStatus: (()->())?
    
    func logoutFromInstagram() {
        Instagram.shared.logout()
        
        photoResponse?.data?.removeAll()
        photoResponse?.pagination = nil
    }
    
    func initiateInstagram() {
        fetch()
    }
    
    func pageRemaining() -> Bool {
        return photoResponse?.pagination?.nextUrl != nil && !fetchingData
    }
    
    func fetch(nextPage: Bool = false) {
        
        if fetchingData {
            return
        }
        
        self.isIntitialLoading = !nextPage
        Endpoints.recentMedia(fromUser: "self",
                                     nextUrl: photoResponse?.pagination?.nextUrl) { (medias, error) in
                                        
                                        self.fetchingData = false
                                        
                                        self.isIntitialLoading = false
                                        guard error == nil else {
                                            self.alertMessage = error.debugDescription
                                            return
                                        }
        
                                        if let response = medias {
                                            // Cache recent responce
                                            self.photoResponse = response
                                            
                                            if let data = response.data {
                                                self.processFetchedPhoto(photos: data)
                                            }
                                        }
        }
    }
    
    func getCellViewModel( at indexPath: IndexPath ) -> CellViewModel {
        return cellViewModels[indexPath.row]
    }
    
    private func processFetchedPhoto( photos: [Media] ) {
        var vms = self.cellViewModels
        for photo in photos {
            vms.append( CellViewModel(media: photo) )
        }
        self.cellViewModels = vms
        
        // refresh
        doOnMain {
            self.reloadTableViewClosure?()
        }
    }
}

extension HomeViewModel {
    func userPressedAllowed( at indexPath: IndexPath ) -> IndexPath? {
        
        if numberOfCells > indexPath.row {
                let photo = cellViewModels[indexPath.row]
                self.selectedPhoto = photo.media
                return indexPath
        }else{
            return nil
        }
    }
}
