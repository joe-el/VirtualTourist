//
//  LocationMapVC+Extension.swift
//  VirtualTourist
//
//  Created by Kenneth Gutierrez on 7/19/22.
//

import Foundation

class TravelLocationView: NSObject {
    weak var delegate: TravelLocationViewDelegate?
    var pinDrops: [Pin] = []
}
