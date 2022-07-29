//
//  PhotoAlbumView.swift
//  VirtualTourist
//
//  Created by Kenneth Gutierrez on 7/22/22.
//

import Foundation
import UIKit
import CoreData

class PhotoAlbumView {
    weak var delegate: PhotoAlbumViewDelegate?
    var pinSelected: Pin?
    var photos: [FlickrPhotoModel] = []
    var currentPage = 1
    
    func downloadPhotoData(_ pageNumber: Int) {
        guard  let pinSelected = pinSelected else {
            return
        }
        pinSelected.photos = nil
        FlickrAPIClient.requestFlickrData(lat: pinSelected.latitude, long: pinSelected.longitude, pageNum: pageNumber, completionHandler: handleSearchedImageResponse(flickrData:error:))
    }
    
    func handleSearchedImageResponse(flickrData: FlickrPhotos?, error: Error?) {
        if error == nil {
            if let results = flickrData?.photos.photo.map({FlickrPhotoModel(urlString: $0.url?.absoluteString ?? "")}) {
                self.photos = results
                self.delegate?.showNoCellView(false)
            }
            if self.photos.isEmpty {
                self.delegate?.showNoCellView(true)
            }
            self.delegate?.loadedPhotos()
        } else {
            print("Download Failed: \(error?.localizedDescription ?? "")")
        }
    }
}
