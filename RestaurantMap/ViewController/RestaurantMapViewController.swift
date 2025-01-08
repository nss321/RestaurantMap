//
//  RestaurantMapViewController.swift
//  RestaurantMap
//
//  Created by BAE on 1/8/25.
//

import UIKit
import MapKit

class RestaurantMapViewController: UIViewController {
    
    @IBOutlet var mapView: MKMapView!
    
    var annotationRawData: [MKAnnotation] {
        var annotations: [MKAnnotation] = []
        RestaurantList().restaurantArray.forEach {
            let singleAnnotation = MKPointAnnotation()
            singleAnnotation.coordinate = CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude)
            singleAnnotation.title = $0.name
            annotations.append(singleAnnotation)
        }
        return annotations
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        configMapView()
        annotationRawData.forEach {
            print($0.title!)
        }
    }

    func configMapView() {
        let center = CLLocationCoordinate2D(latitude: 37.654105, longitude: 127.047968)
        mapView.region = MKCoordinateRegion(center: center, latitudinalMeters: 200, longitudinalMeters: 200)
        mapView.addAnnotations(annotationRawData)
    }
    
    func makeAnnotations() {
        
    }
}

extension RestaurantMapViewController: MKMapViewDelegate {
    
}
