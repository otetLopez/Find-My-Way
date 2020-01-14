//
//  ViewController.swift
//  Find My Way
//
//  Created by otet_tud on 1/14/20.
//  Copyright © 2020 otet_tud. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Define Latitude and Longitude of a specific location ex. Ontario
        let latidude : CLLocationDegrees = 43.64//51.25//43.64
        let longitude: CLLocationDegrees = -79.38//-85.32//-79.38

        // Define the Deltas of Latitude and Longitude
        let latDelta : CLLocationDegrees = 1.0
        let longDelta : CLLocationDegrees = 1.0
        
        // Define the Span
        let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: longDelta)
        
        // Define the location
        let location = CLLocationCoordinate2D(latitude: latidude, longitude: longitude)
        
        // Define the region
        let region = MKCoordinateRegion(center: location, span: span)
        
        // Set MapView with the set region
        mapView.setRegion(region, animated: true)
        
        // Add a double tap gesture
        let uidtgr = UITapGestureRecognizer(target: self, action: #selector(doubleTap))
        uidtgr.numberOfTapsRequired = 2
        mapView.addGestureRecognizer(uidtgr)
    }

    @objc func doubleTap(gestureRecognizer : UIGestureRecognizer) {
        guard let tap = gestureRecognizer as? UITapGestureRecognizer else
          { return }
        
        let touchPoint = gestureRecognizer.location(in: mapView)
        let coordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
            // PIN Location: Add annotation
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
            
        
            
        // Get address for touch coordinates.
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
        if let error = error {
            print(error)
        }  else {
            if let placemark = placemarks?[0] {
                var subThoroufare = ""
                if placemark.subThoroughfare != nil {
                    subThoroufare = placemark.subThoroughfare!
                }
                        
                var thoroufare = ""
                if placemark.thoroughfare != nil {
                    thoroufare = placemark.thoroughfare!
                }
                        
                var subLocality = ""
                if placemark.subLocality != nil {
                    subLocality = placemark.subLocality!
                }
                        
                var subAdministrativeArea = ""
                if placemark.subAdministrativeArea != nil {
                    subAdministrativeArea = placemark.subAdministrativeArea!
                }
                annotation.title = "\(subThoroufare) \(thoroufare) \(subLocality) \(subAdministrativeArea)"
            
                    }
                }}
            if mapView.annotations.count >= 1 {
                mapView.removeAnnotations(mapView.annotations)
            }
            mapView.addAnnotation(annotation)
          
        }    
}

