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
    var currentPage: Int = 1
    
    func downloadPhotoData(_ pageNumber: Int) {
        guard  let pinSelected = pinSelected  else { return }
        pinSelected.photos = nil
        FlickrAPIClient.requestFlickrData(lat: pinSelected.latitude, long: pinSelected.longitude, pageNum: pageNumber) { response, error in
            self.photos = response?.photos.photo.map {
                FlickrPhotoModel(urlString: $0.url?.absoluteString ?? "") } ?? []
            if self.photos.isEmpty {
                self.delegate?.showNoImagesFoundView()
            }
            self.delegate?.loadedPhotos()
        }
        
//        FlickrAPIClient.requestFlickrData(lat: pinSelected.latitude, long: pinSelected.longitude, pageNum: pageNumber, completionHandler: handleSearchedImageResponse(flickrData:error:))
    }
    
    func handleSearchedImageResponse(flickrData: FlickrPhotos?, error: Error?) {
//        FlickrDataModel.flickrData = flickrData?.photos.photo ?? []
        
        self.photos = flickrData?.photos.photo.map {
            FlickrPhotoModel(urlString: $0.url?.absoluteString ?? "")
        } ?? []
        if self.photos.isEmpty {
            self.delegate?.showNoImagesFoundView()
        }
        self.delegate?.loadedPhotos()
    }
    
}
