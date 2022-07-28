//
//  AlbumCollectionViewController.swift
//  VirtualTourist
//
//  Created by Kenneth Gutierrez on 7/4/22.
//

import UIKit
import CoreData
import MapKit

class PhotoAlbumViewController: UIViewController {
    
    //MARK: Properties
    
    var albumView: PhotoAlbumViewProtocol = PhotoAlbumView()
    let photoCell = AlbumPhotoCell()

    //MARK: Outlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var newCollectionButton: UIButton!
    @IBOutlet weak var photoAlbumMapView: MKMapView!
    @IBOutlet var backgroundImage: UIImageView!
    //@IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //MARK: Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        albumView.loadPhotos(albumView.currentPage)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundImage.isHidden = true
        backgroundImage.alpha = 0

        collectionView.delegate = self
        collectionView.dataSource = self
        photoAlbumMapView.delegate = self
        albumView.delegate = self
        albumView.pinMaterialize()
        albumView.loadPhotos(albumView.currentPage)
    }
    
    //MARK: Helper Methods
    
    // remove all existing images from current place
    @IBAction func newCollection(_ sender: Any) {
        albumView.getMorePhotos()
    }

    func setMapAnnotation(){
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: albumView.pinSelected?.latitude ?? 0, longitude: albumView.pinSelected?.longitude ?? 0)
        photoAlbumMapView.addAnnotation(annotation)
        photoAlbumMapView.showAnnotations([annotation], animated: true)
    }
    
    func deleteData(index: Int){
        // Returns the first element of the sequence that satisfies the given predicate.
        if let photo = albumView.pinSelected?.photos?.first(where: { ($0 as? Photo)?.id == albumView.photos[index].urlString}) as? Photo {
            albumView.pinSelected?.removeFromPhotos(photo)
            albumView.photos.remove(at: index)
            collectionView.reloadData()
        }
    }
    
}
