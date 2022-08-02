//
//  LocationSearchTable.swift
//  MapApp
//
//  Created by anita on 26.07.2022.
//

import UIKit
import MapKit



class LocationSearchTable: UITableViewController {
    
    weak var delegate: LocationSearchTableDelegate?
    
    var mapView: MKMapView? = nil
    var matchingItems: [MKMapItem] = []
    var locations = [Location]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(SearchViewCell.self, forCellReuseIdentifier: SearchViewCell.identifier)
        tableView.dataSource = self

       
    }
    
    func parseAddress(selectedItem: MKPlacemark) -> String {
        let firstSpace = (selectedItem.subThoroughfare != nil &&
                                   selectedItem.thoroughfare != nil) ? " " : ""
               
               // put a comma between street and city/state
               let comma = (selectedItem.subThoroughfare != nil || selectedItem.thoroughfare != nil) &&
                           (selectedItem.subAdministrativeArea != nil || selectedItem.administrativeArea != nil) ? ", " : ""
               
               // put a space between "Washington" and "DC"
               let secondSpace = (selectedItem.subAdministrativeArea != nil &&
                                   selectedItem.administrativeArea != nil) ? " " : ""
               
               let addressLine = String(
                   format:"%@%@%@%@%@%@%@",
                   // street number
                   selectedItem.subThoroughfare ?? "",
                   firstSpace,
                   // street name
                   selectedItem.thoroughfare ?? "",
                   comma,
                   // city
                   selectedItem.locality ?? "",
                   secondSpace,
                   // state
                   selectedItem.administrativeArea ?? ""
               )
               
               return addressLine
    }
    
    
}

extension LocationSearchTable: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
        if let text = searchController.searchBar.text, !text.isEmpty {
            LocationManager.shared.findLocations(with: text) { [weak self] location in
                DispatchQueue.main.async {
                    self?.locations += location
                    self?.tableView.reloadData()
                }
            }
        }
    }
    
    
}


// MARK: - Table view data source

extension LocationSearchTable {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchViewCell.identifier) as! SearchViewCell
    
        let selectedItem = locations[indexPath.row]
        cell.locationNameLabel.text = selectedItem.title
        cell.locationAddressLabel.text = selectedItem.address
    
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // Notify map controller to show pin at selected place
        let coordinate = locations[indexPath.row].coordinates
        
        delegate?.locationViewController(didSelectLocationWith: coordinate)
      
        dismiss(animated: true, completion: nil)
    }
    
    
    

}
