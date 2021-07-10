//
//  Restaurant.swift
//  Restaurants
//
//  Created by Sanjeewa Gunathilake on 7/7/21.
//

import Foundation
import UIKit
import CoreLocation

struct Restaurant: Codable {
  let name: String
  let address: String
  let types: [String]
  
  private let geometry: Gemoetry
  var coordinate: CLLocationCoordinate2D {
    return CLLocationCoordinate2D(latitude: geometry.location.lat, longitude: geometry.location.lng)
  }

  enum CodingKeys: String, CodingKey {
    case name
    case address = "vicinity"
    case types
    case geometry
  }
}

extension Restaurant {
  struct Response: Codable {
    let results: [Restaurant]
    let errorMessage: String?
  }
  
  private struct Gemoetry: Codable {
    let location: Coordinate
  }
  
  private struct Coordinate: Codable {
    let lat: CLLocationDegrees
    let lng: CLLocationDegrees
  }
}
