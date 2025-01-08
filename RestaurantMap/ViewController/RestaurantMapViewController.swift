//
//  RestaurantMapViewController.swift
//  RestaurantMap
//
//  Created by BAE on 1/8/25.
//

import UIKit
import MapKit

final class RestaurantMapViewController: UIViewController {
    
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var bigCategorySegmentedControl: UISegmentedControl!
    
    let food = ["한식", "일식", "중식", "양식", "분식"]
    let cafe = ["샐러드", "카페"]
    
    let annotationRawData = RestaurantList().restaurantArray
    
    var allOfAnnotations: [MKAnnotation] {
        var annotations: [MKAnnotation] = []
        annotationRawData.forEach {
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
        allOfAnnotations.forEach {
            print($0.title!)
        }
        
        print(makeCategorisedAnnotationList(categories: cafe, rawData: annotationRawData))
    }

    func configMapView() {
        let center = CLLocationCoordinate2D(latitude: 37.654105, longitude: 127.047968)
        mapView.region = MKCoordinateRegion(center: center, latitudinalMeters: 200, longitudinalMeters: 200)
        mapView.addAnnotations(allOfAnnotations)
    }
    
    @IBAction func categoryChanged(_ sender: UISegmentedControl) {
        print(sender.selectedSegmentIndex)
        mapView.removeAnnotations(mapView.annotations)
        var list: [Restaurant] = []
        var filteredAnnotations: [MKAnnotation] = []
        
        switch sender.selectedSegmentIndex {
        case 0:
            mapView.addAnnotations(allOfAnnotations)
            return
        case 1:
            list = makeCategorisedAnnotationList(categories: food, rawData: annotationRawData)
            filteredAnnotations = makeFilteredAnnotations(data: list)
            mapView.addAnnotations(filteredAnnotations)
            return
        case 2:
            list = makeCategorisedAnnotationList(categories: cafe, rawData: annotationRawData)
            filteredAnnotations = makeFilteredAnnotations(data: list)
            mapView.addAnnotations(filteredAnnotations)
            return
        default:
            return
        }
    }
    
    func makeCategorisedAnnotationList(categories: [String], rawData: [Restaurant]) -> [Restaurant] {
        
        var categorised: [Restaurant] = []
        
        for item in categories {
            let list = rawData.filter{ $0.category == item }
            categorised.append(contentsOf: list)
        }
        
        return categorised
    }
    
    func makeFilteredAnnotations(data: [Restaurant]) -> [MKAnnotation] {
        var annotations: [MKAnnotation] = []
        data.forEach {
            let singleAnnotation = MKPointAnnotation()
            singleAnnotation.coordinate = CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude)
            singleAnnotation.title = $0.name
            annotations.append(singleAnnotation)
        }
        return annotations
    }
    
}

extension RestaurantMapViewController: MKMapViewDelegate {
    
}
