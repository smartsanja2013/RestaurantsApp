//
//  Constants.swift
//  Restaurants
//
//  Created by Sanjeewa Gunathilake on 7/7/21.
//

import Foundation
import MapKit

struct Constants {
    // MARK: - Headers
    static let Main_Title = "Restaurants App"
    
    // MARK: - Api end points
    static let GET_RESTAURANTS_API_ENDPOINT = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?"
    static let PLACE_TYPE = "restaurant" // pass the place type as "restaurant" in google places api
    
    // MARK: - Api keys
    static let GOOGLE_PLACES_APIKEY = "AIzaSyDs8gw6HSWrkSHNNy33zPS_6uY95U_G4eA"
    
    // MARK: - Alerts
    static let Generic_Ok = "OK"
    static let Generic_Done = "Done"
    static let Generic_Error_Message = "Something went wrong. Please try again"
    static let Fetching_Data = "Loading..."
    static let No_Network_Title = "No Network"
    static let No_Network_Message = "Please check your internet connection"
    static let Location_Disabled_Message = "Please check the location services in the Settings"
    
    
    // MARK: - Constant Numerics
    // search radius set to 1km range and pass on to the api
    static let Search_Radius: Double = 1000
    
}
