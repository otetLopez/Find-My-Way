//
//  ViewController.swift
//  Find My Way
//
//  Created by otet_tud on 1/14/20.
//  Copyright © 2020 otet_tud. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    var locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Setup Location Manager
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        // Make sure to add privacy in Info.plist
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        // Can be set on the MKMapView Properties
        mapView.showsUserLocation = true
        
//        // Define Latitude and Longitude of a specific location ex. Ontario
//        let latidude : CLLocationDegrees = 43.64//51.25//43.64
//        let longitude: CLLocationDegrees = -79.38//-85.32//-79.38
//
//        // Define the Deltas of Latitude and Longitude
//        let latDelta : CLLocationDegrees = 1.0
//        let longDelta : CLLocationDegrees = 1.0
//
//        // Define the Span
//        let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: longDelta)
//
//        // Define the location
//        let location = CLLocationCoordinate2D(latitude: latidude, longitude: longitude)
//
//        // Define the region
//        let region = MKCoordinateRegion(center: location, span: span)
//
//        // Set MapView with the set region
//        mapView.setRegion(region, animated: true)
        
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
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // Retrive the user location
        let userLocation : CLLocation = locations[0]
        
        // Set location latitude and longitude
        let latitude = userLocation.coordinate.latitude
        let longitude = userLocation.coordinate.longitude
        
        // Set location deltas
        let latDelta : CLLocationDegrees = 0.05
        let longDelta : CLLocationDegrees = 0.05
        
        let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: longDelta)
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
        
        // Print user location coordinates
        print(userLocation)
        
        // Find the user location address using GeoCoder
        CLGeocoder().reverseGeocodeLocation(userLocation) { (placemarks, error) in
            if let error = error {
                print(error)
            } else {
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
                    
                    var postalCode = ""
                    if placemark.postalCode != nil {
                        postalCode = placemark.postalCode!
                    }
                    
                    var country = ""
                    if placemark.country != nil {
                        country = placemark.country!
                    }
                    
                    print("\(subThoroufare) \(thoroufare)\n\(subLocality) \(subAdministrativeArea)\n\(postalCode) \(country)")
                }
            }
        }
    }

}

