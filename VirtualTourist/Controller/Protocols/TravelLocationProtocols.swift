//
//  MapView.swift
//  VirtualTourist
//
//  Created by Kenneth Gutierrez on 7/21/22.
//

import MapKit
import CoreData

protocol TravelLocationViewDelegate: AnyObject {
    func pinsInserted()
    func zoomToVisibleArea(region: MKCoordinateRegion)
}

protocol TravelLocationViewProtocol {
    var delegate: TravelLocationViewDelegate? { get set }
    var pinDrops: [Pin] { get set }
    func centerToLocation(location: CLLocationCoordinate2D, span: MKCoordinateSpan)
    func addCachedPins()
}

extension TravelLocationView: TravelLocationViewProtocol {
    func centerToLocation(location: CLLocationCoordinate2D, span: MKCoordinateSpan) {
        let coordinateRegion = MKCoordinateRegion(center: location, span: span)
        self.delegate?.zoomToVisibleArea(region: coordinateRegion)
    }
        
    func addCachedPins() {
        pinDrops.removeAll()

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext

        let pinsReq: NSFetchRequest<Pin> = Pin.fetchRequest()
        if let cachedPins = try? context.fetch(pinsReq) {
            self.pinDrops = cachedPins
            delegate?.pinsInserted()
        }
    }
}
