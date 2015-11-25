//
//  ViewController.swift
//  GoogleMapsExample
//
//  Created by haipt on 10/26/15.
//  Copyright © 2015 Framgia. All rights reserved.
//

import UIKit
import GoogleMaps

class ViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet var mapView: GMSMapView!
    var currentLocation: LocationModel!
    let marker: GMSMarker = GMSMarker()
    @IBOutlet weak var tfSearch: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentLocation = LocationDefault
        let camera = GMSCameraPosition.cameraWithLatitude(currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude, zoom: 16)
        self.mapView.camera = camera
        self.mapView.myLocationEnabled = true
        
        marker.position = CLLocationCoordinate2DMake(21.0173236, 105.7837568)
        marker.title = "Framgia"
        marker.snippet = "VietNam"
        marker.map = self.mapView
    }
    
    @IBAction func zoomInTap()
    {
        let currentCamera = mapView.camera
        let newCamera = GMSCameraPosition.cameraWithLatitude(currentCamera.target.latitude, longitude: currentCamera.target.longitude, zoom: currentCamera.zoom+1)
        mapView.animateToCameraPosition(newCamera)
        updateMaker()
    }
    
    @IBAction func zoomOutTap()
    {
        let currentCamera = mapView.camera
        let newCamera = GMSCameraPosition.cameraWithLatitude(currentCamera.target.latitude, longitude: currentCamera.target.longitude, zoom: currentCamera.zoom-1)
        mapView.animateToCameraPosition(newCamera)
        updateMaker()
    }
    
    func updateMaker()
    {
        marker.position = self.currentLocation.coordinate
        marker.title = self.currentLocation.placeName
        marker.snippet = self.currentLocation.placeName
        marker.map = mapView
    }

    
    //MARK - UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField.text != "" {
            var keyword = textField.text!
            keyword = keyword.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            if keyword != "" {
                self.searchPlaceByKeyword(keyword)
            }
        }
        return true
    }
    
    func searchPlaceByKeyword(keyword: String) {
        let helper = GGMapsApiHelper(keyword: keyword)
        weak var weakSelf = self
        helper.startSearchPlace({ (mapsData) -> Void in
            if let strongSelf = weakSelf {
                strongSelf.currentLocation = mapsData
                let newCamera = GMSCameraPosition.cameraWithLatitude(strongSelf.currentLocation.coordinate.latitude, longitude: strongSelf.currentLocation.coordinate.longitude, zoom: 16)
                strongSelf.mapView.animateToCameraPosition(newCamera)
                strongSelf.updateMaker()
                strongSelf.tfSearch.text = mapsData.placeName
                strongSelf.view.endEditing(true)
            }
            }) { (error) -> Void in
                
                
        }
    }
}