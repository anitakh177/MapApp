//
//  LocationManager.swift
//  MapApp
//
//  Created by anita on 26.07.2022.
//

import Foundation
import CoreLocation

struct Location {
    let title: String
    let address: String
    let coordinates: CLLocationCoordinate2D?
}

class LocationManager: NSObject {
    static let shared = LocationManager()
    
    public func findLocations(with query: String, completion: @escaping(([Location]) -> Void)) {
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(query) { places, error in
            guard let places = places, error == nil else {
                completion([])
                return
            }
            
            let models: [Location] = places.compactMap({ place in
                var name = ""
                if let locationName = place.name {
                    name += locationName
                }
                
                
                var address = ""
                if let streetNumber = place.subThoroughfare {
                    address += streetNumber
                }
                
                if let streetName = place.thoroughfare {
                    address += ", \(streetName)"
                }
                if let adminRegion = place.administrativeArea {
                    address += ", \(adminRegion)"
                }
                if let locality = place.locality {
                    address += ", \(locality)"
                }
                if let country = place.country {
                    address += ", \(country)"
                }
                
                print(place)
    
                let result = Location(title: name, address: address, coordinates: place.location?.coordinate)
                
                return result
            })
            completion(models)
        }
        
    }
}
