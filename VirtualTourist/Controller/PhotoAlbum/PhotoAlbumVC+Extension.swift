//
//  PhotoAlbumVC+Extension.swift
//  VirtualTourist
//
//  Created by Kenneth Gutierrez on 7/4/22.
//

import UIKit
import MapKit
import CoreData

//MARK: Properties
let reuseIdent = "Cell"
var hidePhotoCell: Bool = false

//MARK: ColectionView Data Source Methods

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
//        if hidePhotoCell {
//            cell.isHidden = hidePhotoCell
//            cell.backgroundColor = .clear
//            cell.alpha = 0
//            backgroundImage.image = UIImage(named: "NoContent")
//        }
        
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
        
        // if we're still here it means we got a AlbumPhotoCell, so we can return it
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deleteItems(at: [indexPath])
        
        let ac = UIAlertController(title: "Delete?", message: "Remove photo from the album?", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Delete!" , style: .destructive, handler: { _ in
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
    
    func showNoImagesFoundView() {
//        hidePhotoCell = true
        DispatchQueue.main.async { [self] in
            collectionView.displayEmptyView()
//            photoCell.isHidden = true
//            photoCell.alpha = 0
//            backgroundImage.image = UIImage(named: "NoContent")
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

// MARK: Create No Image Found View

extension UICollectionView {
    
    func displayEmptyView() {
        // if there are no photos to download then hide the cell
//        hidePhotoCell = true
        
        let emptyView = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.size.width, height: self.bounds.size.height))
        
        let imageView = UIImageView(image: UIImage(imageLiteralResourceName: "NoContent"))
        
        imageView.backgroundColor = .clear
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        emptyView.addSubview(imageView)
        
        imageView.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor, constant: -20).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        UIView.animate(withDuration: 1, animations: {
            
            imageView.transform = CGAffineTransform(rotationAngle: .pi / 15)
        }, completion: { (finish) in
            UIView.animate(withDuration: 1, animations: {
                imageView.transform = CGAffineTransform(rotationAngle: -1 * (.pi / 15))
            }, completion: { (finish) in
                UIView.animate(withDuration: 1, animations: {
                    imageView.transform = CGAffineTransform.identity
                })
            })
            
        })
        self.backgroundView = emptyView
    }
    
    func restore() {
        self.backgroundView = nil
    }
    
}
