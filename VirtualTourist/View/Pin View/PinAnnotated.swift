//
//  PinLocation.swift
//  VirtualTourist
//
//  Created by Kenneth Gutierrez on 6/23/22.
//

import Foundation
import MapKit

class PinAnnotated: NSObject, MKAnnotation {
    let coordinate: CLLocationCoordinate2D
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
        
        super.init()
    }
}
