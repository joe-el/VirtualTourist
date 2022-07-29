//
//  PhotoAlbumVC+Extension.swift
//  VirtualTourist
//
//  Created by Kenneth Gutierrez on 7/4/22.
//

import UIKit
import MapKit
import CoreData

// MARK: Properties

let reuseIdent = "Cell"
var hideCell: Bool = false

// MARK: ColectionView Data Source Methods

extension PhotoAlbumViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    // numberOfObjects
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albumView.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdent, for: indexPath) as? AlbumPhotoCell else {
            // we failed to get a AlbumPhotoCell – bail out!
            fatalError("Unable to dequeue Photo Album View Cell.")
        }
        
        // if there are no photos to download then hide the cell
        if hideCell {
            cell.isHidden = true
            cell.alpha = 0
            backgroundImage.image = UIImage(named: "NoContent")
        } else {
            let flickrImageUrl = albumView.photos[indexPath.row]
            
            if let urlString = flickrImageUrl.urlString {
                if let pin = albumView.pinSelected {
                    cell.setPhotoImageView(for: pin, from: urlString)
                }
            }
            cell.photoImageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
            cell.photoImageView.layer.borderWidth = 2
            cell.photoImageView.layer.cornerRadius = 3
            cell.layer.cornerRadius = 7
        }
        
        // if we're still here it means we got a AlbumPhotoCell, so we can return it
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let ac = UIAlertController(title: "Delete?", message: "Remove photo from the album?", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Delete!" , style: .destructive, handler: { _ in
            collectionView.deleteItems(at: [indexPath])
            self.deleteData(index: indexPath.row)
            self.collectionView.reloadData()
        }))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
}

//MARK: MapView Data Source Method

extension PhotoAlbumViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
           let reuseId = "pin"
           var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView

           if pinView == nil {
               pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
               pinView!.canShowCallout = false
               pinView!.pinTintColor = .red
            
           } else {
               pinView!.annotation = annotation
           }
           
           pinView?.isSelected = true
           pinView?.isUserInteractionEnabled = false
        
           return pinView
    }
}

//MARK: Photo Album Delegates

extension PhotoAlbumViewController: PhotoAlbumViewDelegate {
    func showNoCellView(_ haveNoPhotos: Bool) {
        if haveNoPhotos == true {
            hideCell = haveNoPhotos
            backgroundImage.isHidden = false
            backgroundImage.alpha = 1
        } else if haveNoPhotos == false {
            hideCell = haveNoPhotos
            backgroundImage.isHidden = true
            backgroundImage.alpha = 0
        }
    }
    
    func zoomToVisibleArea(region: MKCoordinateRegion) {
        DispatchQueue.main.async {
            self.photoAlbumMapView.setRegion(region, animated: true)
        }
    }
    
    func loadedPin() {
        setMapAnnotation()
    }
    
    func loadedPhotos() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func loadMorePhotos() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}
