//
//  PawMapViewController.swift
//  Paw Position
//
//  Created by Chris Tirendi on 8/22/17.
//  Copyright © 2017 Chris Tirendi. All rights reserved.
//

import UIKit
import MapKit

class PawMapViewController: ViewController, MKMapViewDelegate {
    
    // outlets
    @IBOutlet weak var mapView: MKMapView!
    
    let regionRadius: CLLocationDistance = 1000
    let ppLocationManager: PawLocationManager = PawLocationManager.sharedInstance
    
    var annotations: Array<MKAnnotation> = Array<MKAnnotation>()
    var selectedMarker: PawMarker?
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        mapView.delegate = self
        
        ppLocationManager.startUpdatingLocation()
        if let test = ppLocationManager.lastLocation {
            centerOnMapLocation(location: test)
        }
        
        mapView.register(PawMarkerView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        
        // show map object on map - this is for testing
        let message = "Lost dog near some street, likes cheese, is brown with black spots."
        let annotation = PawMarker(title: "Lost Dog", pawName: "Sparky", discipline: "Dog", message: message, coordinate: CLLocationCoordinate2D(latitude: 41.3782, longitude: -73.7128))
        
        annotations.append(annotation)
        mapView.addAnnotations(annotations)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Location
    func centerOnMapLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius,regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    // MARK: - MKMapViewDelegate
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl){
        if control == view.rightCalloutAccessoryView {
            selectedMarker = view.annotation as? PawMarker
            performSegue(withIdentifier: "markDetail", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "markDetail" {
            let pawDetailViewController: PawDetailViewController = segue.destination as! PawDetailViewController
            pawDetailViewController.pawMarkerObject = selectedMarker
        }
    }
}
