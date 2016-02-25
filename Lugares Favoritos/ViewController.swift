//
//  ViewController.swift
//  Lugares Favoritos
//
//  Created by Wladimir Teixeira Neto on 2/1/16.
//  Copyright © 2016 Wladimir Teixeira Neto. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit



class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
   
    @IBOutlet weak var Map: MKMapView!

    var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest //melhor localizacao
        
        if activePlace == -1 {
            locationManager.requestWhenInUseAuthorization() //autorizacao do user
            locationManager.startUpdatingLocation()
        } else {
            let latitude = NSString(string: places[activePlace]["lat"]!).doubleValue
            let longitude = NSString(string: places[activePlace]["long"]!).doubleValue
            
            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let latDelta: CLLocationDegrees = 0.01
            let lonDelta: CLLocationDegrees = 0.01
            let span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
            let region:MKCoordinateRegion = MKCoordinateRegionMake(coordinate, span)
            self.Map.setRegion(region, animated: true)

            
            let annotation = MKPointAnnotation ()
            annotation.coordinate = coordinate
            annotation.title = places[activePlace]["name"]
            self.Map.addAnnotation(annotation)
            
        }
        
        //reconhcedor de gesto inicio
        let uilpgr = UILongPressGestureRecognizer(target: self, action: "action:")
        uilpgr.minimumPressDuration = 2.0 // dois segundos
        Map.addGestureRecognizer(uilpgr)
        //reconhcedor de gesto fim
        
        
        
    }
    
    func action(gestureRecognizer: UIGestureRecognizer) {
        if gestureRecognizer.state == UIGestureRecognizerState.Began {
            let touchPoint = gestureRecognizer.locationInView(self.Map)
            let newcoordinate = self.Map.convertPoint(touchPoint, toCoordinateFromView: self.Map)
            
            let location = CLLocation(latitude: newcoordinate.latitude, longitude: newcoordinate.longitude)
            CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
                var title = ""
                if error == nil {
                    if let p = placemarks?[0]{
                        var address: String = ""
                        var address2: String = ""
                        
                        if p.subThoroughfare != nil {
                            address2 = p.subThoroughfare!
                        }
                        if p.thoroughfare != nil {
                            address = p.thoroughfare!
                        }
                    
                        title = "\(address2) \(address)"
                    }
                    
                    
                }
                //retira os espaços adicionais
                if title.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) == ""{
                    title = "Adicionado em: \(NSDate())"
                }
                
                
                places.append(["name":title, "lat":"\(newcoordinate.latitude)", "long": "\(newcoordinate.longitude)"])
                NSUserDefaults.standardUserDefaults().setObject(places, forKey: "ListaDeLugares")
                
                let annotation = MKPointAnnotation ()
                annotation.coordinate = newcoordinate
                annotation.title = title
                self.Map.addAnnotation(annotation)
                
            })
            
            
            
            
        
        }
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func locationManager(locationManager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0]
        let latitude = userLocation.coordinate.latitude
        let longitude = userLocation.coordinate.longitude
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let latDelta: CLLocationDegrees = 0.01
        let lonDelta: CLLocationDegrees = 0.01
        let span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(coordinate, span)
        self.Map.setRegion(region, animated: true)
        
    }
    
    
        
    

}

