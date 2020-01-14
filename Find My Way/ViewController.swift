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
    var currUserLocation = CLLocationCoordinate2D()
    var toCoordinate = CLLocationCoordinate2D()
    var isCoordinatesSet : Bool = false
    
    //var byAuto : Bool = true
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
            mapView.removeOverlays(mapView.overlays)
        }
        mapView.addAnnotation(annotation)
        //MKPinAnnotationView
        
        // Set destination coordinates
        self.toCoordinate = annotation.coordinate
        isCoordinatesSet = true
    }
    
    func promptTransportType() {
        let alertController = UIAlertController(title: "Transportation", message: "Choose transportation type", preferredStyle: .alert)
             
        let autoAction = UIAlertAction(title: "Auto 🚗", style: .default) { (action) in
            print("DEBUG: User is driving")
            self.setRoute(source: self.currUserLocation, destination: self.toCoordinate, byAuto: true)
        }
             
        let walkAction = UIAlertAction(title: "Walk 🚶🏽", style: .default) { (action) in
            print("DEBUG: User is walking")
            self.setRoute(source: self.currUserLocation, destination: self.toCoordinate, byAuto: false)
        }

        alertController.addAction(autoAction)
        alertController.addAction(walkAction)
                 
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func findmyway(_ sender: UIButton) {
        print("DEBUG: Find My Way!")
        
        if isCoordinatesSet == false {
            let alertController = UIAlertController(title: "Error", message: "Coordinates not yet set", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        } else {
            // Let user choose transport type
            mapView.delegate = self
            promptTransportType()
        }
        
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // Retrive the user location
        let userLocation : CLLocation = locations[0]
        self.currUserLocation = userLocation.coordinate
        
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

    func setRoute(source: CLLocationCoordinate2D, destination: CLLocationCoordinate2D, byAuto : Bool) {
        let sourcePlacemark = MKPlacemark(coordinate: source, addressDictionary: nil)
        let destinationPlacemark = MKPlacemark(coordinate: destination, addressDictionary: nil)
                                
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
                                
        let directionRequest = MKDirections.Request()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = byAuto ? .automobile : .walking
                                
        // Calculate the direction
        let directions = MKDirections(request: directionRequest)
        directions.calculate {
            (response, error) -> Void in
                                    
            guard let response = response else {
                if let error = error {
                    print("Error: \(error)")
                }
                    return
            }
                                    
            let route = response.routes[0]
            self.mapView.addOverlay((route.polyline), level: MKOverlayLevel.aboveRoads)
                                    
            let rect = route.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
        }
    }
}

extension ViewController: MKMapViewDelegate {
    // This function is needed to add overlays
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            //print("Called poly line")
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = UIColor.orange
            renderer.lineWidth = 3
            return renderer
        }
        return MKOverlayRenderer()
    }
}

