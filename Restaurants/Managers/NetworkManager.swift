//
//  NetworkManager.swift
//  Restaurants
//
//  Created by Sanjeewa Gunathilake on 7/7/21.
//
import UIKit
import Foundation
import CoreLocation

typealias RestaurantsCompletion = ([Restaurant]) -> Void
typealias PhotoCompletion = (UIImage?) -> Void

class NetworkManager {
    private var photosDictionary: [String: UIImage] = [:]
    private var placesTask: URLSessionDataTask?
    private var session: URLSession {
        return URLSession.shared
    }
    
    func fetchRestaurants(near coordinate: CLLocationCoordinate2D, radius: Double, completion: @escaping RestaurantsCompletion) -> Void {
        let urlString = "\(Constants.GET_RESTAURANTS_API_ENDPOINT)location=\(coordinate)&radius=\(radius)&rankby=prominence&sensor=true&key=\(Constants.GOOGLE_PLACES_APIKEY)&types=\(Constants.PLACE_TYPE)"
        
        print("urlString \(urlString)")
        
        guard let url = URL(string: urlString) else {
            completion([])
            return
        }
        if let task = placesTask, task.taskIdentifier > 0 && task.state == .running {
            task.cancel()
        }
        placesTask = session.dataTask(with: url) { data, response, _ in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion([])
                }
                return
            }
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            guard let placesResponse = try? decoder.decode(Restaurant.Response.self, from: data) else {
                DispatchQueue.main.async {
                    completion([])
                }
                return
            }
            // capture error
            if let errorMessage = placesResponse.errorMessage {
                print("APIError \(errorMessage)")
            }
            DispatchQueue.main.async {
                completion(placesResponse.results)
            }
        }
        placesTask?.resume()
    }
}
