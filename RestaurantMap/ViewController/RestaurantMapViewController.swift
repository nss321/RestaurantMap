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
    let allCategories = ["한식", "일식", "중식", "양식", "분식", "샐러드", "카페"]
    
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
    
    lazy var filterBarButton: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(filterBarButtonTapped))
        barButtonItem.tintColor = .darkGray
        return barButtonItem
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configMapView()
        setNavigationBar()
//        allOfAnnotations.forEach {
//            print($0.title!)
//        }
//        print(makeCategorisedAnnotationList(categories: cafe, rawData: annotationRawData))
    }
    
    func setNavigationBar() {
        navigationItem.rightBarButtonItem = filterBarButton
    }

    func configMapView() {
        let center = CLLocationCoordinate2D(latitude: 37.654105, longitude: 127.047968)
        mapView.delegate = self
        mapView.region = MKCoordinateRegion(center: center, latitudinalMeters: 200, longitudinalMeters: 200)
        mapView.addAnnotations(allOfAnnotations)
    }
    
    @IBAction func categoryChanged(_ sender: UISegmentedControl) {
//        print(sender.selectedSegmentIndex)
        mapView.removeAnnotations(mapView.annotations)
        var filteredAnnotations: [MKAnnotation] = []
        
        switch sender.selectedSegmentIndex {
        case 0:
            mapView.addAnnotations(allOfAnnotations)
            return
        case 1:
            filteredAnnotations = makeCategorisedAnnotations(categories: food, rawData: annotationRawData)
//            list = makeCategorisedRestaurants(categories: food, rawData: annotationRawData)
//            filteredAnnotations = makeFilteredAnnotations(data: list)
            mapView.addAnnotations(filteredAnnotations)
            return
        case 2:
            filteredAnnotations = makeCategorisedAnnotations(categories: cafe, rawData: annotationRawData)
//            list = makeCategorisedRestaurants(categories: cafe, rawData: annotationRawData)
//            filteredAnnotations = makeFilteredAnnotations(data: list)
            mapView.addAnnotations(filteredAnnotations)
            return
        default:
            return
        }
    }
    
    func makeCategorisedRestaurants(categories: [String], rawData: [Restaurant]) -> [Restaurant] {
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
    
    /// Returns Categorised MKPointAnnotation Array
    /// - Parameters:
    ///   - categories: Categories to filter annotations
    ///   - rawData: Restaurant Struct Array to categorise
    /// - Returns: Categorised MKPointAnnotation Array
    func makeCategorisedAnnotations(categories: [String], rawData: [Restaurant]) -> [MKAnnotation] {
        var categorised: [Restaurant] = []
        var annotations: [MKAnnotation] = []
        
        for item in categories {
            let list = rawData.filter{ $0.category == item }
            categorised.append(contentsOf: list)
        }
        
        categorised.forEach {
            let singleAnnotation = MKPointAnnotation()
            singleAnnotation.coordinate = CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude)
            singleAnnotation.title = $0.name
            annotations.append(singleAnnotation)
        }
        
        return annotations
    }
    
    @objc func filterBarButtonTapped(_ sender: UIBarItem) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(cancel)
        
        for item in allCategories {
            let action = UIAlertAction(title: item, style: .default) { _ in
                self.bigCategorySegmentedControl.selectedSegmentIndex = 0
                let annotations = self.makeCategorisedAnnotations(categories: [item], rawData: self.annotationRawData)
//                self.mapView.removeAnnotations(self.mapView.annotations)
//                self.mapView.addAnnotations(annotations)
                self.mapView.replaceAnnotations(to: annotations)
            }
            alert.addAction(action)
        }
        
        present(alert, animated: true)
    }
}

extension RestaurantMapViewController: MKMapViewDelegate {
    
}

