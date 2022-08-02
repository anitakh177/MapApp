//
//  CurrentLocationViewController.swift
//  MapApp
//
//  Created by anita on 25.07.2022.
//

import UIKit
import CoreLocation
import MapKit

protocol LocationSearchTableDelegate: AnyObject {
    func locationViewController(didSelectLocationWith coordinates: CLLocationCoordinate2D?)
}

class CurrentLocationViewController: UIViewController, LocationSearchTableDelegate {
   
    
    
    private let mapView: MKMapView = {
        let map = MKMapView()
        map.overrideUserInterfaceStyle = .unspecified
        map.showsUserLocation = true
        return map
    }()
    
    private let searchBar: UISearchController = {
        let locationSerachTable = LocationSearchTable()
        let searchBar = UISearchController(searchResultsController: locationSerachTable)
        searchBar.searchBar.searchTextField.backgroundColor = .white
        searchBar.searchBar.placeholder = "Search for places"
        //searchBar.backgroundImage = UIImage()
        searchBar.searchResultsUpdater = locationSerachTable
        return searchBar
    }()
    
   private let locationManager = CLLocationManager()
    private var currentPlace: CLPlacemark?
    
    var locations = [Location]()
    let locationSerachTable = LocationSearchTable()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        //view.addSubview(button)
        setMapConstraints()
        mapView.delegate = self
        attemptLocationAccess()
        navigationItem.titleView = searchBar.searchBar
        searchBar.hidesNavigationBarDuringPresentation = false
        definesPresentationContext = true
        
        locationSerachTable.mapView = mapView
        
        let locationVC = LocationSearchTable()
        locationVC.delegate = self
        
        
    }
    func locationViewController(didSelectLocationWith coordinates: CLLocationCoordinate2D?) {
        
        
        guard let coordinates = coordinates else {
            return
        }
        mapView.removeAnnotations(mapView.annotations)
        let pin = MKPointAnnotation()
        pin.coordinate = coordinates
       
        mapView.addAnnotation(pin)
        
        mapView.setRegion(MKCoordinateRegion(center: coordinates,
                                             span: MKCoordinateSpan(latitudeDelta: 0.07,
                                                                    longitudeDelta: 0.07)),
                                                                    animated: true)
    }
    
    func attemptLocationAccess() {
        guard CLLocationManager.locationServicesEnabled() else {
            return
        }
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        
        locationManager.delegate = self
        let authStatus = locationManager.authorizationStatus
        if authStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        } else {
            locationManager.requestLocation()
        }
        if authStatus == .denied || authStatus == .restricted {
            showLocationServicesDeniedAlert()
        }
    }
    
    private func setMapConstraints() {
        view.addSubview(mapView)
       // view.addSubview(searchBar)
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        //searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            //searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            //searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            //searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
 
    // MARK: - Helper Methods
    func showLocationServicesDeniedAlert() {
        let alert = UIAlertController(title: "Location Services Disabled", message: "Please enable location services for this app in Settings.", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
   

}



extension CurrentLocationViewController: MKMapViewDelegate {
    
}

extension CurrentLocationViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("didFailWithError \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
       let newLocation = locations.last!
        print("didUpdateLocations \(newLocation)")
        
       /*  if let location = locations.first {
            let span = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            mapView.setRegion(region, animated: true)
        }*/
      /*  guard let firstLocation = locations.first else {
            return
        }
        // TODO: Configure MKLocalSearchCompleter here...
        
        CLGeocoder().reverseGeocodeLocation(firstLocation) { places, _ in
            guard let firstPlace = places?.first,
                  self.searchBar.text == nil else {
                return
            }
            
            self.currentPlace = firstPlace
           // self.searchBar.text = firstPlace.abbreviation
        } */
    }
}

