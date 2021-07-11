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
  let permanently_closed: Bool?
  private let geometry: Gemoetry
  private let opening_hours: OpenningHours?
  
  var coordinate: CLLocationCoordinate2D {
    return CLLocationCoordinate2D(latitude: geometry.location.lat, longitude: geometry.location.lng)
  }

  enum CodingKeys: String, CodingKey {
    case name
    case address = "vicinity"
    case types
    case geometry
    case opening_hours
    case permanently_closed
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

  private struct OpenningHours: Codable {
    let open_now: Bool
  }
  
  private struct Coordinate: Codable {
    let lat: CLLocationDegrees
    let lng: CLLocationDegrees
  }
}
