//
//  ViewController.swift
//  GoogleMapsExample
//
//  Created by haipt on 10/26/15.
//  Copyright © 2015 Framgia. All rights reserved.
//

import UIKit
import GoogleMaps

class ViewController: UIViewController {
    @IBOutlet var mapView: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let camera = GMSCameraPosition.cameraWithLatitude(21.0173236, longitude: 105.7837568, zoom: 16)
        self.mapView.camera = camera
        self.mapView.myLocationEnabled = true
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(21.0173236, 105.7837568)
        marker.title = "Framgia"
        marker.snippet = "VietNam"
        marker.map = self.mapView
    }
}