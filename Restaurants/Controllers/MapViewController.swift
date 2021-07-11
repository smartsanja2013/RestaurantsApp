//
//  MapViewController.swift
//  Restaurants
//
//  Created by Sanjeewa Gunathilake on 6/7/21.
//

import Foundation
import UIKit
import MapKit
import CoreLocation
import JGProgressHUD

class MapViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnRefreshLocation: UIButton!
    
    // loading hud
    let hud = JGProgressHUD()
    
    private var locationManager : CLLocationManager!
    private var currentLocation: CLLocation?
    private let networkManager = NetworkManager()
    private let authManager = FirebaseAuthManager()
    var arrAnnotations : [Annotation] = []
    var arrRestaurents : [Restaurant] = []
    var filteredRestaurants = [Restaurant]()
    let searchController = UISearchController(searchResultsController: nil)
    
    // display mapview as default view
    var isMapView = true;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = Constants.Main_Title
        
        // update the display view
        updateView()
        
        // mapview
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        // tap geusture recognizer
        let longTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(longTap))
        mapView.addGestureRecognizer(longTapGesture)
        
        // location manager
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        
        // Check for Location Services availability
        if CLLocationManager.locationServicesEnabled() {
            // request for location services
            locationManager.requestWhenInUseAuthorization()
            
            switch locationManager.authorizationStatus {
            case .notDetermined, .restricted, .denied:
                print("location services disbled for the app")
                // show alert to user
                showDistructiveAlert(title: "", message: Constants.Location_Disabled_Message, buttonText: Constants.Generic_Ok)
            case .authorizedAlways, .authorizedWhenInUse:
                // location services avaialble. start updating location
                locationManager.startUpdatingLocation()
            @unknown default:
                break
                
            }
        }
        else{
            print("Location services disabled in the device")
            // show alert to user
            showDistructiveAlert(title: "", message: Constants.Location_Disabled_Message, buttonText: Constants.Generic_Ok)
        }
        
        // tableview
        tableView.delegate = self;
        tableView.dataSource = self;
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
    }
    
}

// MARK: - Action Methods
extension MapViewController {
    // reload user location
    @IBAction func refreshUserLocation(_ sender: UIButton) {
        locationManager.startUpdatingLocation()
    }
    // toggle mapview and list view
    @IBAction func toggleMapAndList(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            isMapView = true
            updateView()
        case 1:
            isMapView = false
            updateView()
        default:
            break;
        }
    }
    
    // logout user
    @IBAction func logoutButtnTapped(_ sender: UIBarButtonItem) {
        authManager.logout { (loggedOut) in
            if(loggedOut){
                // update isLoggedIn flag
                UserDefaults.standard.set(false, forKey: "isLoggedIn")
                // go back to WelComeViewController
                self.gotoWelComeViewController()
            }
            else{
                print("Error signing out")
            }
        }
    }
    
    // update view
    func updateView() {
        if(isMapView){
            tableView.isHidden = true
            mapView.isHidden = false
            btnRefreshLocation.isHidden = false
        }
        else{
            tableView.isHidden = false
            mapView.isHidden = true
            btnRefreshLocation.isHidden = true
        }
    }
    
    // detect long tap to add annotation on the map
    @objc func longTap(sender: UIGestureRecognizer){
        print("long tap")
        if sender.state == .began {
            let locationInView = sender.location(in: mapView)
            let pinnedLocation = mapView.convert(locationInView, toCoordinateFrom: mapView)
            
            // add 1km overlay
            addMapOverLay(location: pinnedLocation)
            
            // remove all annotations
            arrAnnotations = []
            
            // add pinned annotation
            addAnnotation(name: "Pinned Location", address: "", coordinate: pinnedLocation, tag: 0)
            
            // fetch nearby restaurants based on pinned location
            fetchRestaurants(near: pinnedLocation)
        }
    }
    
    // add annotations to mapview
    func addAnnotation(name: String, address:String, coordinate:CLLocationCoordinate2D, tag:Int){
        let anno = Annotation(
            name: name,
            address: address,
            coordinate: coordinate,
            tag: tag)
        
        arrAnnotations.append(anno)
        
        // add annotation to map
        DispatchQueue.main.async {
            self.mapView.addAnnotations(self.arrAnnotations)
        }
    }
    
    // add overlay to mapview
    func addMapOverLay(location: CLLocationCoordinate2D) {
        // remove all overalys if presents on the mapview
        let overlays = mapView.overlays
        mapView.removeOverlays(overlays)
        
        // define map region
        let viewRegion = MKCoordinateRegion(center: location, latitudinalMeters: 2000, longitudinalMeters: 2000)
        
        // add 1km circle overlay
        let overLay = MKCircle(center: location, radius: Constants.Search_Radius)
        mapView.addOverlay(overLay)
        mapView.setRegion(viewRegion, animated: false)
    }
    
    func gotoWelComeViewController() {
        // set the WelcomeViewController as root
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let welcomeViewController = storyboard.instantiateViewController(identifier: "WelcomeViewController") as! WelcomeViewController
        UIApplication.shared.windows.first?.rootViewController = welcomeViewController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    
    // fetch nearby restaurants
    func fetchRestaurants(near coordinate: CLLocationCoordinate2D) {
        // clear annotations on the map
        self.mapView.removeAnnotations(self.mapView.annotations)
        
        // reset arrRestaurants
        self.arrRestaurents = []
        
        // check internet connection
        if Reachability.isConnectedToNetwork(){
            print("Internet Connection Available!")
            
            // show loadning indicator
            hud.textLabel.text = Constants.Fetching_Data
            hud.show(in: self.view)
            
            // call api
            networkManager.fetchRestaurants(near: coordinate, radius: Constants.Search_Radius) { restaurants in
                guard restaurants.count > 0 else {
                    // no restaurants found. show generic message to user
                    self.showDistructiveAlert(title:"", message:Constants.No_Restaurants_Message, buttonText:Constants.Generic_Ok)
                    self.hud.dismiss()
                    return
                }
                
                // dismiss loading indicator
                self.hud.dismiss()
                
                print("AllRestaurants \(restaurants)")
                
                restaurants.forEach { restaurant in
                    // add annotation
                    self.addAnnotation(name: restaurant.name, address: restaurant.address, coordinate: restaurant.coordinate, tag: 1)
                    
                    // tableview datasource
                    self.arrRestaurents.append(restaurant)
                    self.filteredRestaurants = self.arrRestaurents;
                    self.tableView.reloadData()
                }
            }
        }
        else{
            print("Internet Connection not Available!")
            // show no neteork error message
            self.showDistructiveAlert(title:Constants.No_Network_Title, message:Constants.No_Network_Message, buttonText:Constants.Generic_Ok)
        }
        
    }
    
}

// MARK: - CLLocationManagerDelegate
extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse else {
            return
        }
        locationManager.requestLocation()
        mapView.showsUserLocation = true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        
        // add 1km overlay
        addMapOverLay(location: location.coordinate)
        
        // fetch nearby restaurants based on user location
        arrAnnotations = []
        fetchRestaurants(near: location.coordinate)
        manager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error fetching user location: \(error)")
    }
}

// MARK: - MapView Delegate
extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
        // display only Annotation objects
        guard let annotation = annotation as? Annotation else {
            return nil
        }
        
        let annotationIdentifier = "AnnotationIdentifier"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier)
        
        annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
        
        if(annotation.tag == 1){ // restaurant annotation
            annotationView?.rightCalloutAccessoryView = UIImageView(image: #imageLiteral(resourceName: "open"))
            annotationView!.canShowCallout = true
            annotationView!.image = UIImage(named: "restaurant_pin")
        }
        else{
            annotationView!.canShowCallout = false
            annotationView!.image = UIImage(named: "map_pin")
        }
        
        return annotationView
    }
    
    // 1km circle overlay
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        var circleRenderer = MKCircleRenderer()
        if let overlay = overlay as? MKCircle {
            circleRenderer = MKCircleRenderer(circle: overlay)
            circleRenderer.fillColor = UIColor(named: Constants.BrandColors.SecondaryColor)
            circleRenderer.strokeColor = UIColor(named: Constants.BrandColors.SecondaryTextColor)
            circleRenderer.lineWidth = 0.1
            circleRenderer.alpha = 0.3
            
        }
        return circleRenderer
    }
}

// MARK: - CLLocationCoordinate2D
extension CLLocationCoordinate2D: CustomStringConvertible {
    public var description: String {
        let lat = String(format: "%.6f", latitude)
        let lng = String(format: "%.6f", longitude)
        return "\(lat),\(lng)"
    }
}

// MARK: - TableView Delegates
extension MapViewController: UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredRestaurants.count
        }
        return arrRestaurents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantCellIdentifier", for: indexPath)
        
        let restaurant: Restaurant
        if searchController.isActive && searchController.searchBar.text != "" {
            restaurant = filteredRestaurants[indexPath.row]
        } else {
            restaurant = arrRestaurents[indexPath.row]
        }
        
        cell.textLabel?.text = restaurant.name
        cell.detailTextLabel?.text = restaurant.address
        cell.accessoryView = UIImageView(image:UIImage(named:"open")!)
        return cell
        
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filterRestaurants(for: searchController.searchBar.text ?? "")
    }
    
    private func filterRestaurants(for searchText: String) {
        filteredRestaurants = arrRestaurents.filter { restaurant in
            return restaurant.name.lowercased().contains(searchText.lowercased())
        }
        tableView.reloadData()
    }
    
    
}
