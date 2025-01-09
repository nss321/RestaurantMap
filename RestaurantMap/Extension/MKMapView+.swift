//
//  MKMapView+.swift
//  RestaurantMap
//
//  Created by BAE on 1/9/25.
//

import MapKit

extension MKMapView {
    func replaceAnnotations(to: [MKAnnotation]) {
        self.removeAnnotations(self.annotations)
        self.addAnnotations(to)
    }
}
