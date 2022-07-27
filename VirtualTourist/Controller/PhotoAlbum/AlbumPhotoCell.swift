//
//  ImageViewCell.swift
//  VirtualTourist
//
//  Created by Kenneth Gutierrez on 7/4/22.
//

import UIKit
import CoreData

class AlbumPhotoCell: UICollectionViewCell {
    
    static let reuseIdentifier = "PhotoImageViewCell"
   
    @IBOutlet weak var photoImageView: UIImageView! {
        didSet {
            photoImageView.image = UIImage(named: "ImagePlaceholder")
        }
    }

    func setPhotoImageView(for pin: Pin, from urlString: String) {
        FlickrAPIClient.grabPhoto(pin: pin, urlPath: urlString) { data, error in
            DispatchQueue.main.async {
                guard let data = data else {
                    print("Why photo wasn't set? \(String(describing: error))")
                    return
                }
                self.photoImageView.image = UIImage(data: data)
            }
        }
    }
    
}
