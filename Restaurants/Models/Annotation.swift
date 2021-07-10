//
//  Annotation.swift
//  Restaurants
//
//  Created by Sanjeewa Gunathilake on 7/7/21.
//

import Foundation
import MapKit

class Annotation: NSObject, MKAnnotation {
    
    let name: String?
    let address: String?
    let coordinate: CLLocationCoordinate2D
    let tag: Int // 0: User pinned annotation, 1: Restuarant annotation

    init(name: String?, address: String?, coordinate: CLLocationCoordinate2D, tag: Int) {
        self.name = name
        self.address = address
        self.coordinate = coordinate
        self.tag = tag
        super.init()
      }

    var title: String? {
        return name
    }
    
    var subtitle: String? {
        return address
    }
    
}
