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
    // MARK: Properties
    
    var fetchedResultsController: NSFetchedResultsController<Photo>!
    var albumView: PhotoAlbumViewProtocol = PhotoAlbumView()
    let photoCell = AlbumPhotoCell()

    // MARK: Outlets
    
    @IBOutlet weak var albumCollectionView: UICollectionView!
    @IBOutlet weak var newCollectionButton: UIButton!
    @IBOutlet weak var photoAlbumMapView: MKMapView!
    @IBOutlet var backgroundImage: UIImageView!
    
    // MARK: Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        albumView.loadPhotos(albumView.currentPage)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundImage.isHidden = true
        backgroundImage.alpha = 0

        albumCollectionView.delegate = self
        albumCollectionView.dataSource = self
        albumView.delegate = self
        albumView.pinMaterialize()
        albumView.loadPhotos(albumView.currentPage)
    }
    
    // MARK: Helper Methods
    
    // remove all existing images from current collection view and then download new photos
    @IBAction func newCollection(_ sender: Any) {
        albumView.deleteAllPhotos(from: albumView.pinSelected)
        albumView.getMorePhotos()
    }

    func setMapAnnotation(){
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: albumView.pinSelected?.latitude ?? 0, longitude: albumView.pinSelected?.longitude ?? 0)
        photoAlbumMapView.addAnnotation(annotation)
        photoAlbumMapView.showAnnotations([annotation], animated: true)
    }
    
    func deleteData(index: Int){
        // returns the first element of the sequence that satisfies the given predicate
        if let photoToRemove = albumView.pinSelected?.photos?.first(where: { ($0 as? Photo)?.id == albumView.photos[index].urlString}) as? Photo {
            
            // here the selected photo data is deleted from Core Data
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let context = appDelegate.persistentContainer.viewContext
            
            albumView.pinSelected?.removeFromPhotos(photoToRemove)
            albumView.photos.remove(at: index)
            context.delete(photoToRemove)
            try? context.save()
        }
    }
}
