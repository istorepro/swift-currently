//
//  Nextly.swift
//  Currently
//
//  Created by Mohamed Ismail BENNANI on 15/09/2017.
//  Copyright © 2017 mib. All rights reserved.
//

import CoreLocation
import MapKit
import UIKit

protocol HandlePin {
    func dropPinZoomIn(placemark:MKPlacemark)
}


class Nextly: UIViewController, CLLocationManagerDelegate{
    
    @IBOutlet weak var mapview: MKMapView!
    let locationManager = CLLocationManager()
    var selectedPin:MKPlacemark? = nil

    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
    
    override func viewDidLoad() {
        
        checkLocationAuthorizationStatus()
        
        mapview.userTrackingMode = .follow
        
        DispatchQueue.main.async {
            self.loadSpots()
        }
    }
    
    func centerMapOnLocation(_ location: CLLocation) {
        let regionRadius: CLLocationDistance = 12500
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        mapview.setRegion(coordinateRegion, animated: true)
    }
    
    func loadSpots()
    {

        let Req = MKLocalSearchRequest()
        Req.naturalLanguageQuery = "Bank"
        Req.region = mapview.region
        
        let search = MKLocalSearch(request: Req)
        search.start { response, error in
            guard let response = response else {
                print("There was an error searching for: \(Req.naturalLanguageQuery) error: \(error)")
                return
            }
            
            for item in response.mapItems {
                // Display the received items
                let annotation = MKPointAnnotation()
                annotation.coordinate = item.placemark.coordinate
                annotation.title = item.name
                annotation.subtitle = "Bank"
                self.mapview.addAnnotation(annotation)
                
            }
        }
        let research = MKLocalSearch(request: Req)
        Req.naturalLanguageQuery = "Exchange"
        research.start { response, error in
            guard let response = response else {
                print("There was an error searching for: \(Req.naturalLanguageQuery) error: \(error)")
                return
            }
            
            for item in response.mapItems {
                // Display the received items
                let annotation = MKPointAnnotation()
                annotation.coordinate = item.placemark.coordinate
                annotation.title = item.name
                annotation.subtitle = "Exchange Desks"
                self.mapview.addAnnotation(annotation)
                
            }
        }

    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation { return nil }
        
        if let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "") {
            annotationView.annotation = annotation
            return annotationView
        } else {
            let annotationView = MKPinAnnotationView(annotation:annotation, reuseIdentifier:"")
            annotationView.isEnabled = true
            annotationView.canShowCallout = true
            
            let btn = UIButton(type: .detailDisclosure)
            annotationView.rightCalloutAccessoryView = btn
            return annotationView
        }
    }


    
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapview.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.default
    }
    
}


extension Nextly: HandlePin {
    func dropPinZoomIn(placemark:MKPlacemark){
        // cache the pin
        // selectedPin = placemark
        // clear existing pins
        // mapview.removeAnnotations(mapview.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        if let city = placemark.locality,
            let state = placemark.administrativeArea {
            annotation.subtitle = "(city) (state)"
        }
        mapview.addAnnotation(annotation)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegionMake(placemark.coordinate, span)
        mapview.setRegion(region, animated: true)
    }
}
