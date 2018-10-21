//
//  SatelliteRouteViewController.swift
//  RocketSchedule
//
//  Created by Marcus de Lima on 21/10/18.
//  Copyright © 2018 Peteleco. All rights reserved.
//

import UIKit
import MapKit
import Network

class SatelliteRouteViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet var mapView: MKMapView!
    
    var satelliteLocationLatitude: Double! = nil
    var satelliteLocationLongitude: Double! = nil
    var satelliteLocation: CLLocation! = nil

    
    // MARK: - Satellite Annotation Properties
    var satelliteAnnotation: MKPointAnnotation!
    var satelliteAnnotationPosition = 0
    var orbitPathPolyline: MKGeodesicPolyline! = nil
    
    var satellite: Satellite! = nil
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.mapType = .mutedStandard
        
        mapView.delegate = self
        
        //#Create Route Points (Presicion 0.7)
        
        let LAX = CLLocation(latitude: 33.9424955, longitude: -118.4080684)
        let JFK = CLLocation(latitude: 40.6397511, longitude: -73.7789256)
        
        var coordinates = [LAX.coordinate, JFK.coordinate]
        let geodesicPolyline = MKGeodesicPolyline(coordinates: &coordinates, count: coordinates.count)
        
        let b = UIButton(type: .custom)
        b.setTitle("X", for: .normal)
        b.tintColor = .black
        b.setTitleColor(.black, for: .normal)
        b.layer.cornerRadius = 5
        b.backgroundColor = UIColor(white: 1, alpha: 0.75)
        b.frame = CGRect(x: self.view.frame.maxX*0.8, y: self.view.frame.minY*0.2, width: 50, height: 50)
        b.addTarget(self, action: #selector(dism), for: .touchDown)
        self.view.addSubview(b)
        
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { (ignora) in
            getSatellitePosition(id: 25544) { satpos in
                self.satelliteLocationLatitude = satpos.latitudeA
                self.satelliteLocationLongitude = satpos.longitudeA
                self.satelliteLocation = CLLocation(latitude: self.satelliteLocationLatitude, longitude: self.satelliteLocationLongitude)
                print("\(String(describing: self.satelliteLocation.coordinate))")
                if let s = self.satellite { self.mapView.removeAnnotation(s) }
                self.satellite = Satellite(title: "101", coordinate: self.satelliteLocation.coordinate)
                self.mapView.addAnnotation(self.satellite)
                
                
            }
        }.fire()
       
        mapView.addOverlay(geodesicPolyline)
        
    }
    
    @objc func dism() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Delegate
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyline = overlay as? MKPolyline else {
            return MKOverlayRenderer()
        }
        
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.lineWidth = 3.0
        renderer.alpha = 0.5
        renderer.strokeColor = UIColor.blue
        
        return renderer
    }
    
    
}
