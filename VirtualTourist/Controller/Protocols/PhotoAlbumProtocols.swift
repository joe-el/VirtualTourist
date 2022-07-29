//
//  PhotoAlbumProtocols.swift
//  VirtualTourist
//
//  Created by Kenneth Gutierrez on 7/22/22.
//

import MapKit
import CoreData

protocol PhotoAlbumViewDelegate: AnyObject {
    func showNoCellView(_ haveNoPhotos: Bool)
    func zoomToVisibleArea(region: MKCoordinateRegion)
    func loadedPin()
    func loadedPhotos()
    func loadMorePhotos()
}

protocol PhotoAlbumViewProtocol {
    var delegate: PhotoAlbumViewDelegate? { get set }
    var photos: [FlickrPhotoModel] { get set }
    var pinSelected: Pin? { get set}
    var currentPage: Int { get set}
    func loadPhotos(_ pageNumber: Int)
    func pinMaterialize()
    func getMorePhotos()
}

extension PhotoAlbumView: PhotoAlbumViewProtocol{
    func getMorePhotos(){
        if currentPage <= 100 {
            currentPage = Int.random(in: 1..<100)
            downloadPhotoData(currentPage)
            delegate?.loadMorePhotos()
        }
    }
    
    func pinMaterialize(){
        if pinSelected == pinSelected {
            delegate?.loadedPin()
        }
    }
    
    func loadPhotos(_ pageNumber: Int) {
        guard  let pinSelected = pinSelected  else {
            return
        }
       
        if let photosFromPin = pinSelected.photos?.allObjects as? [Photo] {
            if !photosFromPin.isEmpty {
                photos = photosFromPin.map {
                    FlickrPhotoModel(urlString: $0.id)
                }
                delegate?.loadedPhotos()
            } else {
                downloadPhotoData(pageNumber)
            }
        }
    }
}
